>>ls<<
[ls "option" "file or directory" ]
"option"
$ -l       #ファイルの詳細情報を表示
$ -o       #-lと同じで、グループ情報は表示しない
$ -g       #-lと同じで、ファイル所有者を表示しない
$ --full-time        #-lと同じで、完全な日時を表示する
$ -G       #-lと併用して、グループ名を表示しない
$ --author       #-lと併用して、ファイルの作成者を表示する

$ -h       #-lと併用して、ファイルサイズを読みやすい形式で表示する
$ -k       #-lと併用して、ファイルサイズを1KBで表示する

$ -u       #-lと併用して、更新日の代わりに最終アクセス日を表示する
$ --time=WORD        #-lと併用して、WORD=/-u:atime/-c:status/
$ --time=STYLE       #-lと併用して、STYLE=/full-iso/long-iso/iso/local/FORMAT/

$ -F       #ファイル名の後にタイプ識別子を付けて出力する
$ -p       #ディレクトリの場合、ファイル名の後に/を付けて出力する

$ -i       #ファイル名の前にノード番号を表示する
$ -s       #ファイルのブロック数を表示する
$ -Z       #SELinuxのセキュリティコンテキストを表示する

$ -C       #リストを常に複数の列で出力する
$ -1       #リストを常に一件一行で出力する
$ -m       #ファイルをカンマで区切って出力する
$ -x       #縦方向に複数列で表示する
$ -T"num"        #タブ幅を指定した文字数にする
$ -w"num"        #スクリーン幅を指定した文字数にする
$ --format=WORD        #WORD=/-l:long/-x:across:horizontal/-m:commas/-l:verbose/-1:single-column/-C:vertical/
$ -Q        #ファイル名をダブルクオートで囲んで出力する
$ --quoting-style=WORD        #WORD=/literal/locale/shell/shell-always/c/escape/
$ --color=WHEN        #WHEN=/always/never/auto/
$ -q        #表示不可能な文字を?に置き換えて出力する

$ -t        #更新日が新しい順に出力する
$ -S        #ファイルサイズに大きい順に出力する
$ --group-directories-first       #先にディレクトリを表示してからファイルを表示する
$ --sort=WORD       #WORD=/-U:none/-X:extension/-S:size/-t:time/-v:version/
$ -v        #自然な数字順に出力する
$ -X        #拡張子のアルファベット順に出力する
$ -r        #並び順を反転させる
$ -U        #ファイルを並び替えず、ディレクトリに含まれている要素順で表示する
$ -f        #ファイルを並び替えず、ディレクトリ情報のまま表示する

$ -a        #ドットファイルも表示する
$ -A        #.と..を除くドットファイルも表示する
$ --ignore=PATTERN        #指定したPATTERNに一致する要素は表示しない。Ex)PATTERN=/D*/file[1-3].txt/
$ -d        #ディレクトリの内容でなく、情報を表示する
$ -L        #ディレクトリ内のファイルも含めて、すべてのシンボリックのリンク先の情報を表示する
$ -R        #ディレクトリを指定した場合、再帰的に表示する
>><<


>>cat<<
[cat "option" "file"]
"option"
$ -n        #行番号を付け加える
$ -b        #空白行以外に行番号を加える
$ -s        #連続した空行を一行にする
$ -v        #TAB,改行,改ページ以外の非表示文字を表示する
$ -t        #非表示文字を表示する/TAB:^I/newpage:^L/
$ -E        #行の最後にドルマークを表示する
$ -A        #すべての非表示文字を表示する
$ -e        #TABを除く全ての非表示文字を表示する
>><<


























