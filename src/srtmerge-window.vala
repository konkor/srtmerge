/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * srtmerge-window.vala
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

public class SrtmergeWindow : Gtk.Window {

    public SrtmergeWindow (bool gui) {
        build ();
        initialize (gui);
    }

    private Gtk.Box vbox1;
    private Gtk.InfoBar infoBar;
	private Gtk.Box infoBox;
    private Gtk.HeaderBar hb;
    private Gtk.Button button_add;
    private Gtk.Button button_go;
    private FileSource source1;
    private FileSource source2;
    private FileSource source;
    
    protected void build () {
        set_position (Gtk.WindowPosition.CENTER);
        set_border_width (10);
        hb = new Gtk.HeaderBar ();
        hb.set_show_close_button (true);
        hb.title = Text.app_name;
        hb.subtitle = Text.app_subtitle;
        set_titlebar (hb);

        button_add = new Gtk.Button ();
        button_add.can_default = true;
		button_add.can_focus = true;
		button_add.use_underline = true;
        button_add.tooltip_text = "Add source files";
        Gtk.Image image_add = new Gtk.Image.from_stock (Gtk.Stock.ADD, Gtk.IconSize.BUTTON);
        button_add.add (image_add);
        //hb.pack_start (button_add);

        button_go = new Gtk.Button ();
        button_go.can_focus = true;
		button_go.use_underline = true;
        button_go.tooltip_text = "Merge/Convert subtitles";
        image_add = new Gtk.Image.from_stock (Gtk.Stock.EXECUTE, Gtk.IconSize.BUTTON);
        button_go.add (image_add);
        hb.pack_end (button_go);
        
        vbox1 = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        add (vbox1);

        infoBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
		vbox1.pack_start (infoBox,false,true,0);

        source1 = new FileSource ("Top subtitle source", this);
        vbox1.pack_start (source1, false, false, 6);

        source2 = new FileSource ("Bottom subtitle source", this);
        vbox1.add (source2);

        vbox1.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        vbox1.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

        source = new FileSource ("Output subtitle source", this, false);
        vbox1.add (source);

		set_default_size (550, 480);
        show ();
    }

    private void initialize (bool gui) {
        button_add.clicked.connect (on_add_clicked);
        button_go.clicked.connect (on_go_clicked);

        if (gui) {
            if (Processing.names[0].length != 0) source1.uri = Processing.names[0];
            if (Processing.names[1].length != 0) source2.uri = Processing.names[1];
            if (Processing.names[2].length != 0) source.uri = Processing.names[2];
            if (Processing.codes[0].length != 0) source1.encoder = Processing.codes[0];
            if (Processing.codes[1].length != 0) source2.encoder = Processing.codes[1];
            if (Processing.codes[2].length != 0) source.encoder = Processing.codes[2];
        }
	}

    private void on_add_clicked () {
        string[]? fnames = CustomFileChooser.get_filenames (this);
        if (fnames != null) {
            switch (fnames.length) {
                case 1:
                    
                    break;
                default:
                    break;
            }
        }
    }

    private void on_go_clicked () {
        bool res = Processing.merge (source1.encoder, source1.uri,
                                     source2.encoder, source2.uri,
                                     source.encoder, source.uri,
                                     source1.font, source2.font,
                                     true);
        if (!res) {
            show_error (Debug.last_error);
        } else {
            show_info ("Subtitle has saved to :\n" + source.uri);
        }
    }

    public int show_message (string text, MessageType type = MessageType.INFO) {
        if (infoBar != null) infoBar.destroy ();
        if (type == Gtk.MessageType.QUESTION) {
            infoBar = new InfoBar.with_buttons (Gtk.Stock.YES, Gtk.ResponseType.YES,
                                                Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL);
        } else {
            infoBar = new InfoBar.with_buttons ("gtk-close", Gtk.ResponseType.CLOSE);
            infoBar.set_default_response (Gtk.ResponseType.OK);
        }
        infoBar.set_message_type (type);
        Gtk.Container content = infoBar.get_content_area ();
        switch (type) {
            case Gtk.MessageType.QUESTION:
                content.add (new Gtk.Image.from_stock ("gtk-dialog-question", Gtk.IconSize.DIALOG));
                break;
            case Gtk.MessageType.INFO:
                content.add (new Gtk.Image.from_stock ("gtk-dialog-info", Gtk.IconSize.DIALOG));
                break;
            case Gtk.MessageType.ERROR:
                content.add (new Gtk.Image.from_stock ("gtk-dialog-error", Gtk.IconSize.DIALOG));
                break;
            case Gtk.MessageType.WARNING:
                content.add (new Gtk.Image.from_stock ("gtk-dialog-warning", Gtk.IconSize.DIALOG));
                break;
        }
        content.add (new Gtk.Label (text));
        infoBar.show_all ();
        infoBox.add (infoBar);
        infoBar.response.connect (() => {
			infoBar.destroy ();
			//hide();
		});
        GLib.Timeout.add (5000, on_info_timeout);
        return -1;
    }

    private bool on_info_timeout () {
        Debug.log ("on_info_timeout","on_info_timeout");
        if (infoBar != null)
            infoBar.destroy ();
        return false;
    }

    public int show_warning (string text = "") {
        return show_message (text, MessageType.WARNING);
    }

    public int show_info (string text = "") {
        return show_message (text, MessageType.INFO);
    }

    public int show_error (string text = "") {
        return show_message (text, MessageType.ERROR);
    }

}

