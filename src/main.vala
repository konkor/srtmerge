/* -*- Mode: C; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * main.vala
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

/*
 * The main entry point is now in a separate file so it is possible to test
 * the other components. You cannot have two main entry points in the one
 * program
 */

static int main (string[] args) {

	int32 i = 0;
	bool gui = false;
	Srtmerge.debugging = false;
	
	foreach (string s in args) {
		if (s == "--gui")
		{
			gui = true;
			break;
		}
		if ((s == "-h") || (s == "--help"))
		{
			stdout.printf ("%s\n", Text.app_help);
			return 0;
		}
		if ((s == "-v") || (s == "--version"))
		{
			stdout.printf ("%s\n", Text.app_name + " " + Text.app_version);
			return 0;
		}
		if (s == "--license")
		{
			stdout.printf ("%s\n", "\n" + Text.app_info + "\n\n" + Text.app_license + "\n");
			return 0;
		}
		else if (s == "--debug")
		{
			Srtmerge.debugging = true;
		}
		else if ((s == "-e") || (s == "-o"))
		{
			// Nothing to do yet
		}
		else if (s.has_prefix ("-"))
		{
			stdout.printf ("%s\n", "Unknown option " + s + "\n");
			stdout.printf ("%s\n", Text.app_help);
			return 0;
		}
		//Debug.log ("args" + i.to_string(), s);
		i++;
	}

	if (Processing.Args (args, gui))
		return 0;

	//Starting GUI
	Gtk.init (ref args);
	var app = new Srtmerge (gui);

	Gtk.main ();
	
	return 0;
}