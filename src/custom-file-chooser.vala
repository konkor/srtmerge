/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * custom-file-chooser.vala
 * Copyright (C) 2016 Kapa <kapa76@debian>
 *
 * exaudio is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * exaudio is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using Gtk;

public class CustomFileChooser : Gtk.FileChooserDialog {

    private static string choosenFileName;
	private static string[]? choosenFileNames;
    
    public CustomFileChooser (string? title, Window? w = null, FileChooserAction action = FileChooserAction.OPEN) {
        base.title = title;
        base.parent = w;
        base.action = action;
        add_button ("_Cancel", Gtk.ResponseType.CANCEL);
        add_button ("_Open", Gtk.ResponseType.ACCEPT);
        //set_current_folder(GLib.Environment.get_user_special_dir (GLib.UserDirectory.DOCUMENTS));
        response.connect (() => {
			choosenFileName = base.get_filename ();
			GLib.SList<string> ss = base.get_filenames ();
            uint n = ss.length ();
            int i = 0;
            if (n > 0) {
                choosenFileNames = new string[n];
                foreach (string s in ss) {
                    choosenFileNames[i] = s;
                    i++;
                }
            } else {
                choosenFileNames = null;
            }
			hide();
		});

    }

    public static string? get_directory (Window? w = null) {
		CustomFileChooser dialog = new CustomFileChooser("Choose the folder to add", w, FileChooserAction.SELECT_FOLDER);
		ResponseType response = (ResponseType) dialog.run ();
		dialog.destroy ();
		if (response == ResponseType.ACCEPT)
			return choosenFileName;
		else
			return null;
	}

    public static string[]? get_filenames_array (Window? w = null) {
		CustomFileChooser dialog = new CustomFileChooser("Choose the files to add", w, FileChooserAction.OPEN);
		dialog.select_multiple = true;
		ResponseType response = (ResponseType) dialog.run ();
		dialog.destroy ();
		if (response == ResponseType.ACCEPT)
			return choosenFileNames;
		else
			return null;
	}

    public static string? get_filename_string (Window? w = null) {
		CustomFileChooser dialog = new CustomFileChooser("Choose the file to add", w, FileChooserAction.OPEN);
		dialog.select_multiple = false;
		ResponseType response = (ResponseType) dialog.run ();
		dialog.destroy ();
		if (response == ResponseType.ACCEPT)
			return choosenFileName;
		else
			return null;
	}

    public static string? get_picture (Window? w = null) {
		CustomFileChooser dialog = new CustomFileChooser("Choose the files to add", w, FileChooserAction.OPEN);
		dialog.select_multiple = false;
		Gtk.FileFilter filter_text = new Gtk.FileFilter ();
		filter_text.set_filter_name ("Image files");
		foreach (string s in "image/bmp;image/gif;image/x-tga;image/x-xbitmap;image/tiff;image/jpeg;image/png;image/x-icon;image/svg+xml;image/jp2;image/jpeg2000".split(";")) {
			filter_text.add_mime_type (s);
		}
		dialog.add_filter (filter_text);
		filter_text = new Gtk.FileFilter ();
		filter_text.set_filter_name ("Any files");
		filter_text.add_pattern ("*");
		dialog.add_filter(filter_text);
		ResponseType response = (ResponseType) dialog.run ();
		dialog.destroy ();
		if (response == ResponseType.ACCEPT)
			return choosenFileName;
		else
			return null;
	}

}
