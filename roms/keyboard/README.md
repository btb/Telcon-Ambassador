# Keyboard ROM

The keyboard controller outputs a different scan code for each key combination, which are used to address this ROM. The resulting data byte from the ROM is inverted, and this value is sent to the main board as a literal ASCII character or, if the high bit is set, [some command] that will be interpreted by the terminal itself.

|Modifiers|Key|Scan Code|Value|Result|
|-|-|-|-|-|
||SET<br/>MODE|015|87|[setup]|
||→|01D|83|[cursor right]|
||↑|024|84|[cursor up]|
||←|025|82|[cursor left]|
||BACK<br/>SPACE|029|8f|[backspace]|
||}<br/>]|02B|5d|]|
||LINE<br/>FEED|02C|0a|^J, LF, Line Feed|
||RETURN|02D|8e|[return]|
||HOME|02E|85|[cursor home]|
||↓|030|81|[cursor down]|
||≈<br/>↑|031|5e|^|
||\|<br/>\\ |032|5c|\\ |
||NULL<br/>@|033|40|@|
||{<br/>[|034|5b|[|
||*<br/>:|035|3a|:|
||RUB<br/>OUT<br/>_|036|7f|^?, DEL, Delete|
||[space bar]|037|20|SP, Space|
||'<br/>0|039|30|0|
||=<br/>-|03A|2d|-|
||O|03B|6f|o|
||P|03C|70|p|
||L|03D|6c|l|
||+<br/>;|03E|3b|;|
||><br/>.|03F|2e|.|
||?<br/>/|040|2f|/|
||(<br/>8|041|38|8|
||)<br/>9|042|39|9|
||U|043|75|u|
||I|044|69|i|
||J|045|6a|j|
||K|046|6b|k|
||M|047|6d|m|
||<<br/>,|048|2c|,|
||&<br/>6|049|36|6|
||’<br/>7|04A|37|7|
||T|04B|74|t|
||Y|04C|79|y|
||G|04D|67|g|
||H|04E|68|h|
||B|04F|62|b|
||N|050|6e|n|
||$<br/>4|051|34|4|
||%<br/>5|052|35|5|
||E|053|65|e|
||R|054|72|r|
||D|055|64|d|
||F|056|66|f|
||C|057|63|c|
||V|058|76|v|
||"<br/>2|059|32|2|
||#<br/>3|05A|33|3|
||Q|05B|71|q|
||W|05C|77|w|
||A|05D|61|a|
||S|05E|73|s|
||Z|05F|7a|z|
||X|060|78|x|
||BREAK|061|8c|[break]|
||!<br/>1|062|31|1|
||ESC|063|1b|^[, ESC, Escape|
||PRINT<br/>XMIT|065|88|[transmit screen]|
|SHIFT|SET<br/>MODE|095|87|[setup]|
|SHIFT|→|09D|83|[cursor right]|
|SHIFT|↑|0A4|84|[cursor up]|
|SHIFT|←|0A5|82|[cursor left]|
|SHIFT|BACK<br/>SPACE|0A9|8f|[backspace]|
|SHIFT|}<br/>]|0AB|7d|}|
|SHIFT|LINE<br/>FEED|0AC|0a|^J, LF, Line Feed|
|SHIFT|RETURN|0AD|8e|[return]|
|SHIFT|HOME|0AE|85|[cursor home]|
|SHIFT|↓|0B0|81|[cursor down]|
|SHIFT|≈<br/>↑|0B1|7e|~|
|SHIFT|\|<br/>\\ |0B2|7c|\||
|SHIFT|NULL<br/>@|0B3|00|^@, NUL, Null|
|SHIFT|{<br/>[|0B4|7b|{|
|SHIFT|*<br/>:|0B5|2a|*|
|SHIFT|RUB<br/>OUT<br/>_|0B6|5f|_|
|SHIFT|[space bar]|0B7|20|SP, Space|
|SHIFT|'<br/>0|0B9|60|`|
|SHIFT|=<br/>-|0BA|3d|=|
|SHIFT|O|0BB|4f|O|
|SHIFT|P|0BC|50|P|
|SHIFT|L|0BD|4c|L|
|SHIFT|+<br/>;|0BE|2b|+|
|SHIFT|><br/>.|0BF|3e|>|
|SHIFT|?<br/>/|0C0|3f|?|
|SHIFT|(<br/>8|0C1|28|(|
|SHIFT|)<br/>9|0C2|29|)|
|SHIFT|U|0C3|55|U|
|SHIFT|I|0C4|49|I|
|SHIFT|J|0C5|4a|J|
|SHIFT|K|0C6|4b|K|
|SHIFT|M|0C7|4d|M|
|SHIFT|<<br/>,|0C8|3c|<|
|SHIFT|&<br/>6|0C9|26|&|
|SHIFT|’<br/>7|0CA|27|'|
|SHIFT|T|0CB|54|T|
|SHIFT|Y|0CC|59|Y|
|SHIFT|G|0CD|47|G|
|SHIFT|H|0CE|48|H|
|SHIFT|B|0CF|42|B|
|SHIFT|N|0D0|4e|N|
|SHIFT|$<br/>4|0D1|24|$|
|SHIFT|%<br/>5|0D2|25|%|
|SHIFT|E|0D3|45|E|
|SHIFT|R|0D4|52|R|
|SHIFT|D|0D5|44|D|
|SHIFT|F|0D6|46|F|
|SHIFT|C|0D7|43|C|
|SHIFT|V|0D8|56|V|
|SHIFT|"<br/>2|0D9|22|"|
|SHIFT|#<br/>3|0DA|23|#|
|SHIFT|Q|0DB|51|Q|
|SHIFT|W|0DC|57|W|
|SHIFT|A|0DD|41|A|
|SHIFT|S|0DE|53|S|
|SHIFT|Z|0DF|5a|Z|
|SHIFT|X|0E0|58|X|
|SHIFT|BREAK|0E1|8c|[break]|
|SHIFT|!<br/>1|0E2|21|!|
|SHIFT|ESC|0E3|1b|^[, ESC, Escape|
|SHIFT|PRINT<br/>XMIT|0E5|89|[print screen]|
|CTRL|CLR<br/>SCRN|117|86|[clear screen]|
|CTRL|*<br/>:|135|96|[reset]|
|CTRL|O|13B|0f|^O, SI, Shift In|
|CTRL|P|13C|10|^P, DLE, Data Link Escape|
|CTRL|L|13D|0c|^L, FF, Form Feed|
|CTRL|+<br/>;|13E|1f|^_, US, Unit Separator|
|CTRL|><br/>.|13F|1d|^], GS, Group Separator|
|CTRL|?<br/>/|140|1e|^^, RS, Record Separator|
|CTRL|U|143|15|^U, NAK, Negative Acknowledge|
|CTRL|I|144|99|[tab]|
|CTRL|J|145|0a|^J, LF, Line Feed|
|CTRL|K|146|0b|^K, VT, Vertical Tab|
|CTRL|M|147|0d|^M, CR, Carriage Return|
|CTRL|<<br/>,|148|1c|^\, FS, File Separator|
|CTRL|&<br/>6|149|9c|[enable XON, XOFF]|
|CTRL|T|14B|14|^T, DC4, Tape Off|
|CTRL|Y|14C|19|^Y, EM, End Of Medium|
|CTRL|G|14D|07|^G, BEL, Alert|
|CTRL|H|14E|08|^H, BS, Backspace|
|CTRL|B|14F|02|^B, STX, Start Of Text|
|CTRL|N|150|0e|^N, SO, Shift Out|
|CTRL|$<br/>4|151|98|[indicators off]|
|CTRL|%<br/>5|152|9b|[inhibit XON, XOFF]|
|CTRL|E|153|05|ENQ|
|CTRL|R|154|12|DC2|
|CTRL|D|155|04|EOT|
|CTRL|F|156|06|ACK|
|CTRL|C|157|03|ETX|
|CTRL|V|158|16|SYN|
|CTRL|"<br/>2|159|94|[disable printer]|
|CTRL|#<br/>3|15A|97|[print a space]|
|CTRL|Q|15B|11|^Q, DC1, XON|
|CTRL|W|15C|17|^W, ETB, End Of Transmission Block|
|CTRL|A|15D|01|^A, SOH, Start Of Heading|
|CTRL|S|15E|13|^S, DC3, XOFF|
|CTRL|Z|15F|1a|^Z, SUB, Substitute|
|CTRL|X|160|18|^X, CAN, Cancel|
|CTRL|!<br/>1|162|93|[print incoming data]|
|CTRL|ESC|163|8d|[format tabs]|
|CTRL|PRINT<br/>XMIT|165|8a|[print and transmit screen]|
|SHIFT+CTRL|CLR<br/>SCRN|197|86|[clear screen]|
|SHIFT+CTRL|D|1D5|8b|[no-op?]|
