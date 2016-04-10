/* -*- Mode: C; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * main.c
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

public class Srtmerge : Object 
{
    public static SrtmergeWindow window;
    
    public static bool debugging;

    public Srtmerge (bool gui)
    {
        window = new SrtmergeWindow (gui);

        window.show_all ();
        window.destroy.connect (on_destroy);
    }

    public void on_destroy (Widget window) 
    {
        Gtk.main_quit();
    }

}

