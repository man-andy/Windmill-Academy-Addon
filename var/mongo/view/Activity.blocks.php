<?php
$config = include __DIR__ . "Activity.overview.php";

$config["__name"] = "blocks";

if (isset($config)) {
    foreach ($config["nodes"] as $i => $field) {
        if ($field["fieldname"] == "companyname") {
            unset($config["nodes"][$i]);
        }
        if ($field["fieldname"] == "promo") {
            unset($config["nodes"][$i]);
        }
    }
}
var_dump(__FILE__, $config);die;
return $config;