/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * text.vala
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

public class Text : GLib.Object {

    public const  string app_name                  = "SubRip Merge";
    public const  string app_subtitle              = "It's the tool for 'srt' merging/converting into one single 'ass/srt' file";
    public const  string app_version               = "1.0";
    public const  string app_website               = "https://github.com/konkor/srtmerge/";
    public const  string app_website_label         = "github";
    public static string app_comments;
    public static string app_description;
    public const  string app_copyright             = "Copyright © 2016 Kostiantyn Korienkov";
    public const  string app_license               =
@"SubRip Merger is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

strmerge is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.";
    
    public const  string app_info                  =
@"Srt Merger, a tool for srt subtitles merging.
Copyright © 2016–2016 Kostiantyn Korienkov <kkorienkov@gmail.com>";
            
    public const  string app_help                  =
@"Usage:
  srtmerge [options] [[-e PAGE ]input1.srt] [[-e PAGE ]input2.srt] [[-o] [-e PAGE] FILENAME]

Options:
  -h, --help       Show this help and exit
  -v, --version    Show version number and exit
  --license        Show license and exit
  --debug          Print debug messages
  -e PAGE      Select encoding page for input file
                   (default encoding is UTF-8)
  -o FILENAME      Merged filename to output
  --gui            Start GUI

Examples:
  * Merge sintel_ua.srt and sintel_en.srt to ass format and
  create sintel_merged.ass file with default UTF-8 encoding:
  srtmerge sintel_ua.srt sintel_en.srt sintel_merged.ass

  * Convert sintel_en.srt to ass format and put output to console: 
  srtmerge sintel_en.srt

  * Convert sintel_ua.srt encoded as KOI8U to srt format
  with UTF-8 (default) encoding:
  srtmerge -e KOI8U sintel_ua.srt -o sintel_ua.srt

  * Merge sintel_ua.srt encoded as KOI8U and sintel_en.srt to
  ass format and create sintel_merged.ass file with UTF-8 encoding:
  srtmerge -e KOI8U sintel_ua.srt sintel_en.srt sintel_merged.ass

" + app_info + "\n";

    public const string[] ass_head = {
        "[Script Info]",
        "ScriptType: v4.00+",
        "Collisions: Normal",
        "PlayDepth: 0",
        "Timer: 100,0000",
        "Video Aspect Ratio: 0",
        "WrapStyle: 0",
        "ScaledBorderAndShadow: no",
        "",
        "[V4+ Styles]",
        "Format: Name,Fontname,Fontsize,PrimaryColour,SecondaryColour,OutlineColour,BackColour,Bold,Italic,Underline,StrikeOut," +       "ScaleX,ScaleY,Spacing,Angle,BorderStyle,Outline,Shadow,Alignment,MarginL,MarginR,MarginV,Encoding",
        "Style: Default,Arial,22,&H00FFFFFF,&H00FFFFFF,&H80000000,&H80000000,-1,0,0,0,100,100,0,0,1,3,0,2,10,10,10,0",
        "Style: Top,Arial,22,&H00F9FFFF,&H00FFFFFF,&H80000000,&H80000000,-1,0,0,0,100,100,0,0,1,3,0,8,10,10,10,0",
        "Style: Mid,Arial,22,&H0000FFFF,&H00FFFFFF,&H80000000,&H80000000,-1,0,0,0,100,100,0,0,1,3,0,5,10,10,10,0",
        "Style: Bot,Arial,22,&H00F9FFF9,&H00FFFFFF,&H80000000,&H80000000,-1,0,0,0,100,100,0,0,1,3,0,2,10,10,10,0",
        "",
        "[Events]",
        "Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text"
};

public const string[] encodings = {
"ARMSCII-8", "BIG-5", "BIG5-HKSCS", "CP868", "CP932", "EUC-JP-MS", "EUC-JP",
"EUC-KR", "EUC-TW", "GB2312", "GB13000", "GBK", "GEORGIAN-ACADEMY", "IBM850",
"IBM852", "IBM855", "IBM857", "IBM862", "IBM864", "ISO-2022-CN", "ISO-2022-JP",
"ISO-2022-KR", "ISO-8859-1", "ISO-8859-2", "ISO-8859-3", "ISO-8859-4", "ISO-8859-5",
"ISO-8859-6", "ISO-8859-7", "ISO-8859-8", "ISO-8859-9", "ISO-8859-10",
"ISO-8859-11", "ISO-8859-13", "ISO-8859-14", "ISO-8859-15", "ISO-8859-16", "ISO-IR-111",
"JOHAB", "KOI8-R", "KOI8R", "KOI8U", "SHIFT-JIS", "SHIFT_JIS", "SHIFT_JISX0213", "SJIS-OPEN", "SJIS-WIN", "TCVN", "TIS-620", "UCS-2", "UCS-4", "UHC",
"UNICODE", "UTF-7", "UTF-8", "UTF-16", "UTF-16BE", "UTF-16LE", "UTF-32", "VISCII",
"WINDOWS-31J", "WINDOWS-874", "WINDOWS-936", "WINDOWS-1250", "WINDOWS-1251",
"WINDOWS-1252", "WINDOWS-1253", "WINDOWS-1254", "WINDOWS-1255", "WINDOWS-1256",
"WINDOWS-1257", "WINDOWS-1258"
};

public const string[] formats = {
"ass", "srt"
};
}

