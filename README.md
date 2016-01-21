# Windmill Academy Addon
Addon to implement an academy module in an eportfolio.

## Installation
Add the addon in your composer json: composer require connectholland/academy-addon dev-master

Activate the addon in your WM{clientname}Turbine.php by adding:
```
public function registerAddons()
{
    $addons = parent::registerAddons();
    $addons[] = new AcademyAddon;

    return $addons;
}
```

## Create the etc for your client
Add (at least) three files in Windmill/etc in your own client for adding your custom database name, tulip urls, environments etc. The files are called:
* eportfolio_academy.xml
* eportfolio_academy-acceptance.xml
* eportfolio_academy-development.xml

Your eportfolio_academy.xsl should contain:
```
<turbine>
    <client>
        <type>academy</type>
    </client>
</turbine>
<windmill>
    <framework>
        <designtemplate>
            <default>academy</default>
        </designtemplate>
        <ufts>
            <default>academy</default>
        </ufts>
    </framework>
</windmill>
```

## Client modules
If you have client specific modules like Wmactivityeportfolio{clientname} you can extend them from the modules in the addon:
```
class Wmactivityeportfolio{clientname}Settings extends WmactivityeportfolioacademyaddonCMS
{
}
```
or:
```
use ConnectHolland\Eportfolio\Addon\Academy\Mongo\Activity as AcademyActivity;
class Activity extends AcademyActivity
{
}
```

## Create the required files
Based on the set designtemplate and uft in the etc you should also create those files:
* Windmill/uft/academy.xsl
* Windmill/xsl/academy.xsl

In those files you can import the default files from the skin like:
```
<xsl:import href='../../vendor/connectholland/eportfolio-material-design-skin/views/uft/eportfolio.xsl'/>
```
