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

//using Gtk;
/**internal Srtmerge getApp()
{
    return (Srtmerge) GLib.Application.get_default();
}**/

public class Srtmerge : Gtk.Application 
{
    public static SrtmergeWindow window;
    public static bool debugging;
    private bool gui;
    //private Settings settings;

    private const GLib.ActionEntry[] action_entries = {
        {"about", about_cb},
        {"quit", quit_cb}
    };

    public Srtmerge (bool gui) {
        Object (application_id: "org.gtk.srtmerge", flags: ApplicationFlags.HANDLES_OPEN);
        this.gui = gui;
    }

    protected override void startup () {
        base.startup ();
        add_action_entries (action_entries, this);
        GLib.Menu section = new GLib.Menu ();
        section.append_item (new GLib.MenuItem ("About", "app.about"));
        section.append_item (new GLib.MenuItem ("Quit", "app.quit"));
        GLib.Menu menu = new GLib.Menu ();
        menu.append_section (null, section);
        this.set_app_menu ((GLib.MenuModel) menu);
        set_accels_for_action ("app.quit", {"<Primary>q"});

        Environment.set_application_name (Text.app_name);

        window = new SrtmergeWindow (gui, this);
        window.show_all ();
    }

    protected override void activate () {
        window.present ();
    }

    private void quit_cb () {
        window.destroy ();
    }

    protected override void shutdown() {
        base.shutdown();
    }

    private void about_cb () {
        string[] authors = {
          "Kostiantyn Korienkov",
          null
        };
        Gtk.show_about_dialog (window,
                               "name", Text.app_name,
                               "copyright", Text.app_copyright,
                               "license-type", Gtk.License.GPL_3_0,
                               "authors", authors,
                               "website", Text.app_website,
		                       "website-label", Text.app_name,
                               "version", Text.app_version,
                               "logo_icon_name", "srtmerge",
                                null);
    }

    

}

