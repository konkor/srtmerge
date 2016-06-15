/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * processing.vala
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

public class Processing {
    private static bool _top = true;

    public static string[] names;
    public static string[] codes;

    public static bool Args (string[] args, bool gui = false) {
        int i, pos = 0, count = args.length;
        string[] fname = {"", "", ""};
        string[] encoding = {"", "", ""};

        for (i = 1; i < count; i++) {
            Debug.log ("args[%d]".printf (i), args[i]);
            if (pos > 2) break;
            if ((args[i] == "-e") || (args[i] == "-o") || (args[i] == "--gui") || (args[i] == "--debug")) {
                switch (args[i]) {
                    case "-e":
                        if (i + 2 < count) {
                            if (exist (args[i + 2])) {
                                encoding[pos] = args[i + 1];
                                fname[pos] = args[i + 2];
                                pos++;
                                i += 2;
                            } else {
                                Debug.error (args[i + 2], "It should be an existen file.");
                                return false;
                            }
                        } else {
                            Debug.error ("args parsing error", "usage: -e ENCODING filename.srt");
                            return false;
                        }
                        break;
                    case "-o":
                        if (i + 2 < count) {
                            encoding[2] = (args[i + 1]);
                            fname[2] = (args[i + 2]);
                            i += 2;
                        } else {
                            fname[2] = (args[i + 1]);
                            i += 1;
                        }
                        break;
                }
            } else {
                if (exist (args[i])) {
                    fname[pos] = (args[i]);
                    //Debug.log ("fname[%d]".printf(pos), fname[pos]);
                    pos++;
                } else {
                    Debug.error (args[i], "It should be an existen file.");
                    return false;
                }
            }
        }
        if ( pos == 0) return false;

        if (gui) {
            names = fname;
            codes = encoding;
            return false;
        } else {
            return merge (encoding[0], fname[0],
                          encoding[1], fname[1],
                          encoding[2], fname[2]);
        }
    }

    private static SrtFont f1;
    private static SrtFont f2;

    public static bool merge (string enc1, string fn1,
                              string enc2, string fn2,
                              string enc, string fn,
                              SrtFont? top_font = null, SrtFont? bot_font = null,
                              bool is_gui = false) {
        GLib.List<Title> timeline1, timeline2;

        if (is_gui && (fn.length == 0)) {
            Debug.error ("Processing.merge", "Output file not selected.");
            return false;
        }
        _top = true;
        if (top_font == null)
            f1 = new SrtFont (Pango.FontDescription.from_string ("Normal bold 22"));
        else
            f1 = top_font;
        if (bot_font == null)
            f2 = new SrtFont (Pango.FontDescription.from_string ("Normal bold 22"));
        else
            f2 = bot_font;
        Debug.info ("merge f1", "%s %s %s %s %s".printf (f1.name, f1.bold, f1.italic, f1.size, f1.color));
        if (fn1 != "") {
            timeline1 = parse (enc1, fn1);
            if (timeline1 == null) {
                Debug.error ("Processing.merge", "Parsing error of " + fn1);
                return false;
            }
            _top = false;
        } else {
            Debug.error ("Processing.merge", "Source file not selected.");
            return false;
        }
        if (fn2 != "") {
            timeline2 = parse (enc2, fn2);
            if (timeline2 == null) {
                Debug.error ("Processing.merge", "Parsing error of " + fn2);
            }
        } else {
            return export (timeline1, enc, fn);
        }
        return export (join (timeline1, timeline2), enc, fn);
    }

    public static List<Title>? parse (string enc, string fn) {
        List<Title> timeline = new List<Title> ();
        File file = File.new_for_path (fn);
        Title t= new Title (_top);
        int pos = 0;

        if (!file.query_exists ()) {
            Debug.error ("Parsing", "File '%s' doesn't exist.\n".printf (file.get_path ()));
            return null;
        }
        try {
            DataInputStream dis = new DataInputStream (file.read ());
            string line, s;
            while ((line = dis.read_line (null)) != null) {
                //stdout.printf ("[%d]%s\n", line.length, line);
                line = line.replace ("\r", "");
                if (line == "") {
                    //stdout.printf ("[%d]\n", t.Number);
                    if ((t.Number > 0) && (t.Text.length () > 0)) {
                        timeline.append (t);
                        t= new Title (_top);
                        pos = 0;
                    }
                    if (t.Number == 0) pos = 0;
                } else {
                    if (enc != "") {
                        try {
                            s = convert (line, -1, "UTF-8", enc);
                        } catch (ConvertError er) {
                            Debug.error ("Encoding " + enc, er.message);
                            return null;
                        }
                    } else {
                        s = line;
                    }
                    switch (pos) {
                        case 0:
                            t.Number = int.parse (s.strip ());
                            break;
                        case 1:
                            int i = s.index_of (" --> ");
                            if (i > 0) {
                                t.Start = parse_time (s.substring (0, i));
                                i += " --> ".length;
                                t.End = parse_time (s.substring (i));
                            }
                            break;
                        default:
                            t.AddString (s);
                            break;
                    }
                    pos++;
                }
            }
            Debug.info ("Parsed", timeline.length().to_string ());
        } catch (Error e) {
            Debug.error ("Parsing", e.message);
        }
        return timeline;
    }

    private static DateTime parse_time (string s) {
        DateTime t = new DateTime.utc (1970,1,1,0,0,0);
        int j, hour = 0, minute = 0;
        double seconds = 0.0;
        string s1 = s;

        //Debug.info ("parse_time", s);
        j = s1.index_of (":");
        if (j > -1) {
            hour = int.parse (s1[0:j]);
            s1 = s1.substring (j + 1);
            j = s1.index_of (":");
            if (j > -1) {
                minute = int.parse (s1[0:j]);
                s1 = s1.substring (j + 1);
                j = s1.index_of (",");
                if (j > -1) {
                    seconds = double.parse (s1[0:j]);
                    s1 = s1.substring (j + 1);
                    seconds += double.parse (s1)/1000;
                } else {
                    return t;
                }
            } else {
                return t;
            }
        }
        if (hour > 0) t=t.add_hours (hour);
        if (minute > 0) t=t.add_minutes (minute);
        if (seconds > 0.0) t=t.add_seconds (seconds);
        //Debug.log ("parsed", t.format ("%T")+",%d".printf (t.get_microsecond ()));
        return t;
    }

    public static List<Title> join (List<Title> tl1, List<Title> tl2) {
        List<Title> timeline = new List<Title> ();
        uint i = 0, n = tl2.length();

        foreach (Title t in tl1) {
            //Debug.log ("join","%u %u".printf (i, n));
            if (i < n) {
                while (t.Start.compare (((Title) tl2.nth (i).data).Start)==1) {
                    timeline.append (((Title) tl2.nth (i).data));
                    i++;
                    if (i==n) break;
                }
            }
            timeline.append (t);
        }
        //Debug.log ("join","%u %u".printf (i, n));
        for (i = i + 0; i < n; i++) {
            timeline.append (((Title) tl2.nth (i).data));
        }
        return timeline;
    }

    public static bool export (GLib.List<Title> timeline, string enc, string fn) {
        if (fn.length == 0) {
            return export_ass (timeline, enc, fn);
        } else {
            if (fn.up().has_suffix (".SRT")) {
                return export_srt (timeline, enc, fn);
            } else {
                return export_ass (timeline, enc, fn);
            }
        }
    }

    public static string convert_to (string str, string enc) {
        string s = str;
        if (enc.length == 0) return s;
        if (enc != "UTF-8") {
            try {
                s = convert (s, -1, enc, "UTF-8");
            } catch (ConvertError er) {
                Debug.error (er.message, s);
                return s;
            }
        } else {
            return s;
        }
        return s;
    }

    public static bool export_ass (GLib.List<Title> timeline, string enc, string fn) {
        File file;
        DataOutputStream dos = null;
        string s;

        if (fn.length != 0) {
            file = File.new_for_path (fn);
            if (file.query_exists ()) {
                try {
                    file.delete ();
                } catch (Error e) {
                    Debug.error ("export_ass", e.message);
                }
            }
            try {
                dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
            } catch (Error e) {
                Debug.error ("export_ass", e.message);
            }
        }
        foreach (string str in Text.ass_head) {
            s = str;
            if (s.has_prefix ("Style: Top,")) {
                if (f1.enable_style)
                    s = "Style: Top,%s,%s,&H00%s,&H00FFFFFF,&H80000000,&H80000000,%s,%s,0,0,100,100,0,0,1,3,0,8,10,10,10,0".printf (
                        f1.name, f1.size, f1.color_ass, f1.bold, f1.italic);
                else
                    s = "Style: Top,Normal,22,&H00FFFFFF,&H00FFFFFF,&H80000000,&H80000000,0,0,0,0,100,100,0,0,1,3,0,8,10,10,10,0";
            } else if (s.has_prefix ("Style: Bot,")) {
                if (f2.enable_style)
                    s = "Style: Bot,%s,%s,&H00%s,&H00FFFFFF,&H80000000,&H80000000,%s,%s,0,0,100,100,0,0,1,3,0,2,10,10,10,0".printf (
                        f2.name, f2.size, f2.color_ass, f2.bold, f2.italic);
                else
                    s = "Style: Bot,Normal,22,&H00FFFFFF,&H00FFFFFF,&H80000000,&H80000000,0,0,0,0,100,100,0,0,1,3,0,8,10,10,10,0";
            }
            s = convert_to (s, enc);
            if (fn.length == 0) {
                stdout.printf ("%s\r\n", s);
            } else {
                try {dos.put_string (s + "\r\n");} catch (Error e) {Debug.error ("export_ass", e.message);}
            }
        }
        foreach (Title t in timeline) {
            t.clear ();
            if (t.Top) {
                s = "Dialogue: 0,%d:%02d:%02d.%02d,%d:%02d:%02d.%02d,Top,,0000,0000,0000,,%s".printf (
                    t.Start.get_hour (), t.Start.get_minute (), t.Start.get_second (),
                    t.Start.get_microsecond ()/10000, t.End.get_hour (), t.End.get_minute (), t.End.get_second (),
                    t.End.get_microsecond ()/10000, t.GetString());
            } else {
                s = "Dialogue: 0,%d:%02d:%02d.%02d,%d:%02d:%02d.%02d,Bot,,0000,0000,0000,,%s".printf (
                    t.Start.get_hour (), t.Start.get_minute (), t.Start.get_second (), 
                    t.Start.get_microsecond ()/10000, t.End.get_hour (), t.End.get_minute (), t.End.get_second (),
                    t.End.get_microsecond ()/10000, t.GetString());
            }
            s = convert_to (s, enc);
            if (fn.length == 0) {
                stdout.printf ("%s\r\n", s);
            } else {
                try {dos.put_string (s + "\r\n");} catch (Error e) {Debug.error ("export_ass", e.message);}
            }
        }
        return true;
    }

    public static bool export_srt (GLib.List<Title> timeline, string enc, string fn) {
        File file;
        DataOutputStream? dos = null;
        uint i = 0, n = timeline.length (), index = 1;
        TimeSpan d = 0, d1 = 0, d3;
        Title t1, t2, t3, t;

        if (fn.length != 0) {
            file = File.new_for_path (fn);
            if (file.query_exists ()) {
                try {
                    file.delete ();
                } catch (Error e) {
                    Debug.error ("export_srt", e.message);
                }
            }
            try {
                dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
            } catch (Error e) {
                Debug.error ("export_srt", e.message);
            }
        }
        //apply style
        for (i = 0; i < n; i++) {
            t1 = (Title) timeline.nth (i).data;
            if ((t1.Top && f1.clear_style) || (t1.Bottom && f2.clear_style)) {
                t1.clear ();
            }
            if (t1.Top && f1.enable_style) {
                t1.AddColor (f1);
            } else if (t1.Bottom && f2.enable_style) {
                t1.AddColor (f2);
            }
        }
        for (i = 0; i < n; i++) {
            t1 = (Title) timeline.nth (i).data;
            if (i + 1 < n) {
                t2 = (Title) timeline.nth (i + 1).data;
                if (t1.Top == t2.Top) {
                    t1.Number = index;
                    srt_output (t1, enc, dos);
                } else {
                    d = (int64) t2.Start.difference ( t1.Start);
                    d1 = (int64) t1.End.difference ( t2.Start);
                    Debug.log ("index", "%u".printf (index));
                    Debug.log ("d", "%jd = %s - %s".printf (d, t1.Start.format("%T"), t2.Start.format("%T")));
                    Debug.log ("d1", "%jd = %s - %s".printf (d1, t2.Start.format("%T"), t1.End.format("%T")));
                    //if (d < 500000 && d1>100000) {
                    if (d1 > 500000) {
                        d3 = 0;
                        if (i + 2 < n) {
                            t3 = (Title) timeline.nth (i + 2).data;
                            if (t1.Top != t3.Top) {
                                d3 = (int64) t1.End.difference ( t3.Start);
                            }
                        }
                        if (t1.Top) {
                            t = t1;
                        } else {
                            t = t2;
                        }
                        t.Number = index;
                        t.Start = t1.Start;
                        if (t1.Top) {
                            foreach (string s in t2.Text) {
                                t.AddString (s);
                            }
                        } else {
                            foreach (string s in t1.Text) {
                                t.AddString (s);
                            }
                        }
                        srt_output (t, enc, dos);
                        if ((t2.Duration - d1) < 500000) {
                            i++;
                        } else {
                            t2.Start = t1.End;
                        }
                        if (d3 > 500000) {
                            t1.Start = t2.End;
                            t2 = t1;
                        }
                    } else {
                        t1.Number = index;
                        srt_output (t1, enc, dos);
                    }
                }
            } else {
                t1.Number = index;
                srt_output (t1, enc, dos);
            }
            index++;
        }
        return true;
    }

    private static void srt_output (Title t, string enc, DataOutputStream? dos = null) {
        string s;
        if (dos == null) {
            s = "%u\n".printf (t.Number);
            stdout.printf ("%s", convert_to (s, enc));
            s = "%s,%03d --> %s,%03d\n".printf (t.Start.format ("%T"), t.Start.get_microsecond ()/1000,
                                                t.End.format ("%T"), t.End.get_microsecond ()/1000);
            stdout.printf ("%s", convert_to (s, enc));
            foreach (string str in t.Text) {
                stdout.printf ("%s", convert_to (str + "\n", enc));
            }
            stdout.printf ("%s", convert_to ("\n", enc));
        } else {
            try {
                s = "%u\n".printf (t.Number);
                dos.put_string (convert_to (s, enc));
                s = "%s,%03d --> %s,%03d\n".printf (t.Start.format ("%T"), t.Start.get_microsecond ()/1000,
                                                    t.End.format ("%T"), t.End.get_microsecond ()/1000);
                dos.put_string (convert_to (s, enc));
                foreach (string str in t.Text) {
                    dos.put_string (convert_to (str + "\n", enc));
                }
                dos.put_string (convert_to ("\n", enc));
            } catch (Error e) {
                Debug.error ("srt_output", e.message);
            }
        }
    }

    public static bool exist (string filepath) {
        GLib.File file = File.new_for_path (filepath.strip ());
        return file.query_exists ();
    }
}
