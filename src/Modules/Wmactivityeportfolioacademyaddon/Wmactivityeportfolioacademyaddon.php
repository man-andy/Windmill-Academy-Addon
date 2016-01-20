<?php

/**
 * Wmactivityeportfolioacademyaddon is a module that handles Activities for an Academy module in Eportfolio
 *
 * @author Deborah van der Vegt
 */
use Windmill\Modules\Wmmongo\MongoObject;
use Windmill\Modules\Wmmongo\ObjectFactory;
// use Windmill\Modules\Wmmongoeportfolio\Activity;
// use Windmill\Modules\Wmactivityeportfolio\Activityevent;

class WmactivityeportfolioacademyaddonSettings extends WmactivityeportfolioCMS
{
}

class Wmactivityeportfolioacademyaddon extends WmactivityeportfolioacademyaddonSettings
{
    /**
     * Sets the tagname for xml
     *
     * @param $mode
     * @return string
     */
    public function getModuleInModeTagname($mode)
    {
        return "activities";
    }

    /**
     * Performances actions identified by $mode
     *
     * @param MongoCriteria $mc
     * @return $mc
     */
    protected function handleMode(MongoCriteria $mc)
    {
        switch ($this->mode) {
            case 'categories':
                $this->setFilterset("categories");
                $this->applyFilters($mc);
                $mc->add("_id", -1);
                break;
            case 'spotlight':
                $this->view = "blocks";
                $mc->add("spotlight", true);
                $mc->add("activity_type", array("", "rekenen-en-taal"), MongoCriteria::NOT_IN);
                $mc->setLimit(3);
                break;
            case 'related':
                $this->view = "blocks";
                $mc->add("special", true);
                $mc->add("activity_type", array("", "rekenen-en-taal"), MongoCriteria::NOT_IN);
                $mc->setLimit(3);
                break;
        }

        $this->addSearchForm($mc);

        return parent::handleMode($mc);
    }

    /**
     * Returns the basic form name
     *
     * @return string
     */
    protected function getBasicFormName()
    {
        return "activity";
    }

    /**
     * Returns the url where the user can find the overview of vacancies
     *
     * @return string
     */
    protected function getOverviewUrl()
    {
        return "/" . strtolower(WMLanguage::translate("cursussen"));
    }

    /**
     * Removes the option Rekenen en taal in the filter on the homepage
     *
     * @param MongoCriteria $mc
     * @param array $filter
     * @return $result
     */
    protected function getFilterOptions(MongoCriteria $mc, array $filter)
    {
        $result = parent::getFilterOptions($mc, $filter);

        if ($this->mode === "categories") {
            $result->add("activity_type", "rekenen-en-taal");
        }

        return $result;
    }
}

class WmactivityeportfolioacademyaddonCMS extends Wmactivityeportfolioacademyaddon
{
}
