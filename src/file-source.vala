/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * file-source.vala
 * Copyright (C) 2016 Kostiantyn Korienkov <kkorienkov [at] gmail.com>
 *
 * srtmerge is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * srtmerge is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;

public class FileSource : Gtk.Bin {
    private Gtk.Box vbox1;
    private Gtk.Box hbox_title;
    private Gtk.Label label_title;
    private Gtk.Box hbox_path;
    private Gtk.Entry entry_path;
    private Gtk.Button button_path;
    private Gtk.Box hbox_tools;
    private Gtk.ComboBoxText combo_encode;
    public Gtk.FontButton font_button;
    private Gtk.ColorButton color_button;
    private Gtk.ComboBoxText combo_format;
    private Gtk.ToggleButton clear_style_btn;
    private Gtk.ToggleButton enable_style_btn;
    
    private SrtmergeWindow w;
    private bool input_source;
    
    public FileSource (string title, SrtmergeWindow _w, bool input_source = true) {
        w = _w;
        this.input_source = input_source;

        vbox1 = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        add (vbox1);

        hbox_title = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        vbox1.add (hbox_title);

        label_title = new Gtk.Label (title);
        label_title.set_alignment (0, 0.5F);
        label_title.override_font (Pango.FontDescription.from_string ("Normal bold"));
        hbox_title.pack_start (label_title, false, false, 6);

        hbox_path = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        vbox1.add (hbox_path);

        entry_path = new Gtk.Entry ();
        hbox_path.pack_start (entry_path, true, true, 6);

        button_path = new Gtk.Button ();
        button_path.can_focus = true;
		button_path.use_underline = true;
        button_path.label = "...";
        button_path.tooltip_text = "Select a file source";
        button_path.clicked.connect (on_button_path_clicked);
        hbox_path.pack_end (button_path, false, false, 0);

        hbox_tools = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        vbox1.add (hbox_tools);

        Gtk.Label label = new Gtk.Label ("Encoding");
        
        combo_encode = new Gtk.ComboBoxText.with_entry ();
        combo_encode.append_text ("");
        foreach (string s in Text.encodings) {
            combo_encode.append_text (s);
        }
        Entry entry = (Entry)combo_encode.get_child();
        entry.text = "UTF-8";
        hbox_title.pack_end (combo_encode, false, false, 0);
        hbox_title.pack_end (label, false, false, 0);

        if (input_source) {
            label = new Gtk.Label ("Font");
            hbox_tools.add (label);

            font_button = new Gtk.FontButton ();
            hbox_tools.add (font_button);
            Pango.FontDescription font = font_button.get_font_desc ();
            font.set_size (22 * Pango.SCALE);
            font.set_weight (Pango.Weight.BOLD);
            font_button.set_font_desc (font);

            color_button = new Gtk.ColorButton ();
            hbox_tools.add (color_button);
            Gdk.RGBA rgb = Gdk.RGBA ();
		    //bool tmp = rgb.parse ("#FFFFFF");
		    //assert (tmp == true);
            rgb.parse (_color);
		    color_button.rgba = rgb;

            clear_style_btn = new Gtk.ToggleButton ();
            clear_style_btn.tooltip_text = "Clear the old style";
            clear_style_btn.set_active (true);
            //Gtk.Image image = new Gtk.Image.from_stock ("gtk-clear", Gtk.IconSize.BUTTON);
            Gtk.Image image = new Gtk.Image ();
            image.pixbuf = new Gdk.Pixbuf.from_file (Config.IMAGE_DIR + "/style_clear.png");
            clear_style_btn.add (image);
            hbox_tools.pack_end (clear_style_btn, false, false, 0);

            //enable_style_btn = new Gtk.ToggleButton.with_label ("Enable styling");
            enable_style_btn = new Gtk.ToggleButton ();
            enable_style_btn.tooltip_text = "Enable styling";
            enable_style_btn.set_active (true);
            image = new Gtk.Image ();
            image.pixbuf = new Gdk.Pixbuf.from_file (Config.IMAGE_DIR + "/style.png");
            enable_style_btn.add (image);
            hbox_tools.pack_end (enable_style_btn, false, false, 0);
        } else {
            label = new Gtk.Label ("Format");
            hbox_tools.add (label);

            combo_format = new Gtk.ComboBoxText ();
            foreach (string s in Text.formats) {
                combo_format.append_text (s.up ());
            }
            combo_format.active = 0;
            hbox_tools.add (combo_format);

            combo_format.changed.connect (() => {
                string s = combo_format.get_active_text ();
                //clear_style.sensitive = s == "SRT";
                if (entry_path.text.strip ().length == 0) return;
                if (entry_path.text.up ().has_suffix (".ASS")) {
                    if (s == "SRT") {
                        entry_path.text = entry_path.text.substring (0, entry_path.text.up ().index_of (".ASS")) + ".srt";
                    }
                } else if (entry_path.text.up ().has_suffix (".SRT")) {
                    if (s == "ASS") {
                        entry_path.text = entry_path.text.substring (0, entry_path.text.up ().index_of (".SRT")) + ".ass";
                    }
                } else {
                    entry_path.text += "." + s.down ();
                }
                
	    	});
        }

    }

    private void on_button_path_clicked () {
        string? filename = null;
        if (input_source)
            filename = CustomFileChooser.get_subtitle (w, "application/x-subrip;");
        else
            filename = CustomFileChooser.set_subtitle (w, "text/x-ssa;application/x-subrip;");
        if (filename!=null) {
            if (filename.up().has_suffix (".SRT") && (input_source == false)) {
                combo_format.set_active (1);
            } else if (input_source == false) {
                combo_format.set_active (0);
            }
            entry_path.text = filename;
        }
    }

    public string uri {
        get {
            return entry_path.text;
        }
        set {
            entry_path.text = value;
        }
        default = "";
    }

    private string _encoder = "UTF-8";
    public string encoder {
        get {
            _encoder = combo_encode.get_active_text ().strip ();
            if (_encoder.length < 2)
                return "UTF-8";
            else
                return _encoder;
        }
        set {
            _encoder = value;
            var entry = (Entry)combo_encode.get_child();
            entry.text = _encoder;
        }
    }

    public bool exist {
        get {
            return Processing.exist (entry_path.text);
        }
    }

    private string _color = "#FFFFFF";
    public string color {
        get {
            _color = "#%02X%02X%02X".printf ((uint) (color_button.rgba.red * 255),
                                             (uint) (color_button.rgba.green * 255),
                                             (uint) (color_button.rgba.blue * 255));
            return _color;
        }
    }

    private SrtFont _font;
    public SrtFont font {
        get {
            _font = new SrtFont (font_button.get_font_desc (), color);
            _font.clear_style = clear_style_btn.active;
            _font.enable_style = enable_style_btn.active;
            return _font;
        }
    }

}

