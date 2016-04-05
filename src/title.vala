/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * title.vala
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

    public void clear () {
        int i, j;
        uint ind, n = _body.length();
        string s;
        for (ind = 0; ind < n; ind++) {
            s = _body.nth (ind).data;
            if (s.index_of ("</font>") > -1) {
                _body.nth (ind).data = s.replace ("</font>", "");
                s = _body.nth (ind).data;
            }
            i = s.index_of ("<font color=");
            if (i > -1) {
                j = s.index_of (">", i);
                if (j > -1) {
                    //Debug.log ("title 0", s);
                    _body.nth (ind).data = s.substring (0, i) + s.substring (j + 1);
                    //Debug.log ("title 1", s);
                }
            }
        }
    }
 }



