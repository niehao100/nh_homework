for file in `find . -name "*.java"`
do
    echo 'enca -L zh_CN -x UTF-8 '$file
    enca -L zh_CN -x UTF-8 $file
done

