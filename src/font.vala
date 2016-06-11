/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * font.vala
 * Copyright (C) 2016 Kostiantyn Korienkov <kkorienkov [at] gmail.com>
 *
 * strmerge is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * strmerge is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class SrtFont : GLib.Object {

    public SrtFont (Pango.FontDescription desc, string color_str = "#FFFFFF") {
        color = color_str;
        name = desc.get_family ();
        if (desc.get_style () == Pango.Style.ITALIC)
            italic = "-1";
        else
            italic = "0";
        if (desc.get_style () == Pango.Style.OBLIQUE)
            italic = "-1";
        if (desc.get_weight () > Pango.Weight.NORMAL)
            bold = "-1";
        else
            bold = "0";
        size = "%.0f".printf (desc.get_size () / Pango.SCALE);
    }

    public string name {
        get;
        set;
        default = "Sans";
    }

    public string bold {
        get;
        set;
        default = "-1";
    }

    public string italic {
        get;
        set;
        default = "0";
    }

    public string underline {
        get;
        set;
        default = "0";
    }

    public string strike {
        get;
        set;
        default = "0";
    }

    public string size {
        get;
        set;
        default = "22";
    }

    //private string _col = "#FFFFFF";
    public string color {
        get;
        set;
        default = "#FFFFFF";
    }

    private string _colass;
    public string color_ass {
        get {
            _colass = color.substring (5,2) + color.substring (3,2) + color.substring (1,2);
            return _colass;
        }
    }

    public bool clear_style {
        get;
        set;
        default = true;
    }

    private bool _enable_style = true;
    public bool enable_style {
        get { return _enable_style;}
        set { _enable_style = value;}
    }
}

