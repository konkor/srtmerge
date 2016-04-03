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
    
    public CustomFileChooser (Gtk.Window? w = null, string? title = null,
                              FileChooserAction action = FileChooserAction.OPEN,
                              string? current_folder = null) {
        if (title != null) set_title (title);
        set_transient_for (w);
        base.action = action;
        add_button ("_Cancel", Gtk.ResponseType.CANCEL);
        if (action == FileChooserAction.CREATE_FOLDER)
            add_button ("Create", Gtk.ResponseType.ACCEPT);
        else if (action == FileChooserAction.SAVE) 
            add_button ("_Save", Gtk.ResponseType.ACCEPT);
        else
            add_button ("_Open", Gtk.ResponseType.ACCEPT);
        //GLib.Environment.get_user_special_dir (GLib.UserDirectory.DOCUMENTS)
        if (current_folder !=null)
            set_current_folder (current_folder);
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

    public static string? directory (Gtk.Window? w = null,
                                     string title = "Select a folder",
                                     FileChooserAction action = FileChooserAction.SELECT_FOLDER) {
        CustomFileChooser dialog = new CustomFileChooser(w, title, action);
		ResponseType response = (ResponseType) dialog.run ();
		dialog.destroy ();
		if (response == ResponseType.ACCEPT)
			return choosenFileName;
        return null;
    }

    public static string? get_directory (Gtk.Window? w = null) {
		return directory (w);
	}

    public static string? set_directory (Gtk.Window? w = null) {
		return directory (w, "Create a folder", FileChooserAction.CREATE_FOLDER);
	}

    public static string[]? filenames (Gtk.Window? w = null,
                                       bool select_multiple = true,
                                       string? title = null,
                                       Gtk.FileChooserAction action = Gtk.FileChooserAction.OPEN,
                                       string? filter_name = null,
                                       string? mimetypes = null) {
        string _title = "Select file(s)";
        if (title!=null) _title = title;
        CustomFileChooser dialog = new CustomFileChooser (w, _title, action);
		dialog.select_multiple = select_multiple;
        if (filter_name!=null && mimetypes!=null) {
            Gtk.FileFilter filter_text = new Gtk.FileFilter ();
	    	filter_text.set_filter_name ("Subtitle files");
            foreach (string s in mimetypes.split(";")) {
	    		if (s != "") filter_text.add_mime_type (s);
	    	}
	    	dialog.add_filter (filter_text);

	    	filter_text = new Gtk.FileFilter ();
	    	filter_text.set_filter_name ("Any files");
	    	filter_text.add_pattern ("*");
	    	dialog.add_filter(filter_text);
        }
		ResponseType response = (ResponseType) dialog.run ();
		dialog.destroy ();
		if (response == ResponseType.ACCEPT)
			return choosenFileNames;
        return null;
    }

    public static string[]? get_filenames (Gtk.Window? w = null,
                                           string? title = null,
                                           string? filter_name = null,
                                           string? mimetypes = null) {
		return filenames (w, true, title, Gtk.FileChooserAction.OPEN, filter_name, mimetypes);
	}

    public static string[]? save_filenames (Gtk.Window? w = null,
                                            string? title = null,
                                            string? filter_name = null,
                                            string? mimetypes = null) {
		return filenames (w, true, title, Gtk.FileChooserAction.SAVE, filter_name, mimetypes);
	}

    public static string? get_filename (Gtk.Window? w = null,
                                        string? title = null,
                                        string? filter_name = null,
                                        string? mimetypes = null) {
		string[]? s = filenames (w, false, title, Gtk.FileChooserAction.OPEN, filter_name, mimetypes);
		if (s != null)
			return s[0];
		else
			return null;
	}

    public static string? save_filename (Gtk.Window? w = null,
                                         string? title = null,
                                         string? filter_name = null,
                                         string? mimetypes = null) {
		string[]? s = filenames (w, false, title, Gtk.FileChooserAction.SAVE, filter_name, mimetypes);
		if (s != null)
			return s[0];
		else
			return null;
	}

    static const string image_mimes = "image/bmp;image/gif;image/x-tga;image/x-xbitmap;image/tiff;" +
                                      "image/jpeg;image/png;image/x-icon;image/svg+xml;image/jp2;image/jpeg2000";
    public static string? get_picture (Gtk.Window? w = null, string? mimetypes = null) {
        string mimes = image_mimes;
        if (mimetypes != null) mimes = mimetypes;
        return get_filename (w, "Select a picture", "Image files", mimes);  
	}

    static const string sub_mimes = "text/x-microdvd;text/x-ssa;application/x-subrip;text/x-subviewer;";

    public static string? get_subtitle (Gtk.Window? w = null, string? mimetypes = null) {
        string mimes = sub_mimes;
        if (mimetypes != null) mimes = mimetypes;
        return get_filename (w, "Select a subtitle", "Subtitles", mimes);
    }

    public static string? set_subtitle (Gtk.Window? w = null, string? mimetypes = null) {
        string mimes = sub_mimes;
        if (mimetypes != null) mimes = mimetypes;
        return save_filename (w, "Select a subtitle", "Subtitles", mimes);
    }

}
