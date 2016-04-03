/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * title.vala
 * Copyright (C) 2016 Kapa <kkorienkov@gmail.com>
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

public class Title : GLib.Object {

    public Title (bool top = true) {
        _body = new List<string>();
        Top = top;
    }

    private List<string> _body;
    public List<string> Text {
        get {return _body;}
    }

    public void AddString (string s) {
        _body.append (s);
    }

    public void AddColor (string s) {
        _body.first ().data = "<font color=\"" + s + "\">" + _body.first ().data;
        _body.last ().data += "</font>";
    }

    public string GetString () {
        string s = "";
        int i = 0;
        foreach (string t in _body) {
            if (i==0) {
                s += t;
                i++;
            } else {
                s += "\\N" + t;
            }
        }
        return s;
    }

    public uint Number {
        get;
        set;
        default = 0;
    }

    public DateTime Start {
        get;
        set;
        default = new DateTime.utc (1970,1,1,0,0,0);
    }
 
    public DateTime End {
        get;
        set;
        default = new DateTime.utc (1970,1,1,0,0,0);
    }

    public TimeSpan? Duration {
        get {
            return End.difference (Start);
        }
        default = null;
    }

    public bool Top {
        get;
        set;
        default = true;
    }

    public bool Bottom {
        get {return !Top;}
        set {Top = !value;}
    }
 }

public class Font : GLib.Object {

    public Font (Pango.FontDescription desc, string color_str = "#FFFFFF") {
        color = color_str;
        name = desc.get_family ();
        if (desc.get_style () == Pango.Style.ITALIC)
            italic = "-1";
        else
            italic = "0";
        if (desc.get_weight () > Pango.Weight.NORMAL)
            bold = "-1";
        else
            bold = "0";
        size = "%.0f".printf (desc.get_size () / Pango.SCALE);
        //Debug.info ("Font", size);
    }

    public string name {
        get;
        set;
        default = "Sans";
    }

    public string bold {
        get;
        set;
        default = "0";
    }

    public string italic {
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
}

