\" This is a comment that is not rendered

.R1
no-label-in-reference
accumulate
.R2

.TL
title	\" comment: the title of the document goes here
.AU
author

.bp

.NH
heading with toc entry
.XS
heading with toc entry
.XE
.LP
toc entry generated with .XS .XE

No first line indentation paragraph with .LP
.PP
First line indented paragraph with .PP
.QP
All lines of paragraph will be indented, with .QP
.LP
Enter a double eol to create a newline inside a paragraph.

Groff glyph names can be found with
.QS
man groff_char
.QE
Glyphs can be entered with: \\[Code]
For example: \\[181]
.SH
Custom list bullets
.IP \[bu]
list item with .IP \\[bu]
.IP *
list item with .IP *
.SH
Custom list indentation
.IP 1 0
list item with .IP 1 0
.IP 2 1
list item with .IP 2 1
.IP 3 2
list item with .IP 3 2
.IP 4 3
list item with .IP 4 3
.IP 5 4
list item with .IP 5 4
.IP 6 5
list item with .IP 6 5
.SH
Standard list item indentation
.IP 7
list item with .IP 7
.LP
Normal paragraph with .LP
.in 1
add 1 indentation to current mode witn .in 1
.in 5
add 5 indentation to curent mode with .in 5
.LP
Reset to normal with .LP again.

.SH
Bibliography
.LP
reference to bibliography is done with:
.QS
 .[ search_term .]
.QE
For example a reference to a mathmatics
.[
math_exponent_2c
.]
book.

.SH accumulate
.LP
With the 'accumulate' option references are printed at the end of the document,
or when
.QS
 .[ $LIST$ .]
.QE
is called. For example at the end of every chapter.

.NH
heading without toc entry
.SH
Subheading with .SH
.LP
.sp 2
linespacing with .sp (this line has .sp 2)
.br
next line linespacing is normal again
.br
pagebreak with .bp
.br
linebreak with .br
.br
.ce 2
center next two lines
.br
with .ce 2
third line is normal again
.NH
.XN "pdfroff -mspdf heading21"
.LP
Heading with .XN "heading_name"

Groff can not read the .XN heading name.
Groff can not place the toc at the beginning of the document.
With "pdfroff -mspdf" this can be processed.

.NH
Color
.NH 2
Defining
.defcolor rgb 1 0 0 red
.defcolor #00FF00 green
.LP
we define a rgb colorcode and name it 'red': .defcolor rgb 1 0 0 red

we define a hex color code and name it 'green': .defcolor #00FF00 green

.NH 2
Printing
.NH 3
inline
.LP
the word \m[red]red\m[] text is written in red

The inline code for red: \\m[red]\m[red]red text\m[]\\m[]

.NH 3
whole block
.LP
.gcolor green
the whole block will be written in green

the color starts with: .gcolor green

the color resets with: .gcolor
.gcolor

.NH 2
Register values
We can get the color register value with: \\n[.m]\\n[] \n[.m]\n[]

.NH 2
Switching
.LP
Disable color codes with: .color 0

Enable color codes with: .color 1

.NH
Changing the font
.SH
Inline
.LP
Changing the font can be done inline with: \\f[B]bold\\f[]
.IP B
\f[B]bold\f[]
.IP I
\f[I]italic\f[]
.IP BI
\f[BI]bold italic\f[]
.IP CW
\f[CW]constant width\f[]
.LP
.sp 1
With .DOT codes
.IP .B
.B	bold
.IP .I
.I	italic
.IP .BI
.BI	bold_italic
.IP	.CW
.CW constant_width
.IP .UL
.UL underline
.SH
Blocks
.LP
.in 2
.ft CW
this is a indented code block
.br
the indentation is 2 with:	.in 2
.br
then to set the font:		.ft CW
.br
and to reset the font:		.ft P
.ft P
.LP
.in 2
can also be set with the inline code:		\\f[CW] ... \\f[]
.LP
.br
.ps 6
font size 6 with .ps 6
.LP
font size resets with .LP
.br
font size resets with .LP

.NH
Boxes
.LP
.B1
Boxed text (page wide) with: .B1 ... .B2
.B2
.BX "Boxed text (text wide) with: .BX and text in quotes"

.ce 3
.BX
.br
"Centered text in a box"
.br


.bp
.TC

