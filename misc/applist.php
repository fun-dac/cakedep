<?php
//ドキュメントルート以下で展開したブランチを一覧
function getDirList($trgDir){
    $ignore_dir = array("redmine", "githook", "rockmongo");
    $a = array();
    if ($dir = opendir($trgDir)) {
        while (($file = readdir($dir)) !== false) {
            if ($file != "." && $file != "..") {
                if(is_dir($trgDir.'/'.$file)){
                    if(!in_array($file, $ignore_dir)){
                        $info["name"] = $file;
                        $info["date"] = date("Y/m/d H:i:s", filemtime($file));
                        array_push($a, $info);
                    }
                }
            }
        }
        closedir($dir);
        return $a;
    }
}

// ディレクトリの一覧を取得
$dir_list = getDirList("./");
?>

<!DOCTYPE html>
<html>
    <head>
        <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.1.1/css/bootstrap-combined.min.css" rel="stylesheet">
        <style type="text/css">
            .bs-docs-example {
            position: relative;
            margin: 15px 0;
            padding: 39px 19px 14px;
            background-color: white;
            border: 1px solid #DDD;
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
            border-radius: 4px;
            }
            .bs-docs-example::after {
            content: "Deployed Branches";
            position: absolute;
            top: -1px;
            left: -1px;
            padding: 3px 7px;
            font-size: 14px;
            background-color: whiteSmoke;
            border: 1px solid #DDD;
            color: #9DA0A4;
            -webkit-border-radius: 4px 0 4px 0;
            -moz-border-radius: 4px 0 4px 0;
            border-radius: 4px 0 4px 0;
            }
        </style>
    </head>
    <body>
        <div class="bs-docs-example">
            <table class="table table-striped">
                <thead>
                    <tr><th>branch name</th><th>deploy date</th>
                </thead>
                <tbody>
                <?php
                    foreach($dir_list as $dir){
                        echo '<tr>';
                        echo '<td><a href="'.$dir['name'].'" target="_blank">';
                        echo $dir['name'].'</a></td>';
                        echo '<td>'.$dir['date'].'</td>';
                        echo '</tr>';
                    }
                ?>
                </tbody>
            </table>
        </div>
    </body>
</html>
