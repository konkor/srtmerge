/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * file-source.vala
 * Copyright (C) 2016 Kapa <kkorienkov@gmail.com>
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
    private Gtk.Label label_title;
    private Gtk.Box hbox_path;
    private Gtk.Entry entry_path;
    private Gtk.Button button_path;
    private Gtk.Box hbox_tools;
    private Gtk.Label label_encode;
    private Gtk.ComboBoxText combo_encode;
    
    private SrtmergeWindow w;
    
    public FileSource (string title, SrtmergeWindow _w) {
        w = _w;
        vbox1 = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        add (vbox1);

        label_title = new Gtk.Label (title);
        label_title.set_alignment(0, 0);
        vbox1.pack_start (label_title, false, false, 6);

        hbox_path = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        vbox1.add (hbox_path);

        entry_path = new Gtk.Entry ();
        hbox_path.pack_start (entry_path, true, true, 0);

        button_path = new Gtk.Button ();
        button_path.can_focus = true;
		button_path.use_underline = true;
        button_path.label = "...";
        button_path.tooltip_text = "Select a file source";
        button_path.clicked.connect (on_button_path_clicked);
        hbox_path.pack_end (button_path, false, false, 0);

        hbox_tools = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        vbox1.add (hbox_tools);

        combo_encode = new Gtk.ComboBoxText.with_entry ();
        combo_encode.append_text ("");
        foreach (string s in Text.encodings) {
            combo_encode.append_text (s);
        }
        hbox_tools.add (combo_encode);
        combo_encode.changed.connect (() => {
			//string title = box.get_active_text ();
		});

        
    }

    private void on_button_path_clicked () {
        string? filename = CustomFileChooser.get_directory (w);
        if (filename!=null) {
            entry_path.text = filename;
        }
    }

}

