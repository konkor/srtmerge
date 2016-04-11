/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * source-entry.vala
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

public class SourceEntry : Gtk.Entry {

    public SourceEntry () {
    }

    protected override void drag_data_received (Gdk.DragContext context, int x, int y, Gtk.SelectionData selection_data, uint info, uint time_) {
        string? file = selection_data.get_text ();
        if (file != null) {
            file = file.replace("file://","").replace("\r\n","");
            file = Uri.unescape_string (file);
            text = file;
        }
        Gtk.drag_finish (context, true, false, time_);
    }
}

