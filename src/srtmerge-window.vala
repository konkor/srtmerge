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

    public SrtmergeWindow () {
        build ();
        initialize ();
    }

    private Gtk.Box vbox1;
    public Gtk.InfoBar infoBar;
	private Gtk.Box hboxInfo;
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
        hb.pack_start (button_add);

        button_go = new Gtk.Button ();
        button_go.can_focus = true;
		button_go.use_underline = true;
        button_go.tooltip_text = "Merge/Convert subtitles";
        image_add = new Gtk.Image.from_stock (Gtk.Stock.EXECUTE, Gtk.IconSize.BUTTON);
        button_go.add (image_add);
        hb.pack_end (button_go);
        
        vbox1 = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        add (vbox1);

        hboxInfo = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
		vbox1.pack_start (hboxInfo,false,true,0);

        source1 = new FileSource ("Top subtitle source", this);
        vbox1.pack_start (source1, false, false, 6);

        source2 = new FileSource ("Bottom subtitle source", this);
        vbox1.add (source2);

        vbox1.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

        source = new FileSource ("Output subtitle source", this, false);
        vbox1.add (source);

		set_default_size (560, 480);
        show ();
    }

    private void initialize () {
        button_add.clicked.connect (on_add_clicked);
        button_go.clicked.connect (on_go_clicked);
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
                                     new SrtFont (source1.font_button.get_font_desc (), source1.color),
                                     new SrtFont (source2.font_button.get_font_desc (), source2.color));
        if (!res) {
            //error
        } else {
            //ready
        }
    }
}

