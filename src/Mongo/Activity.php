<?php

namespace ConnectHolland\Eportfolio\Addon\Academy\Mongo;

use Windmill\Modules\Wmactivityeportfolio\Activity as BaseActivity;

class Activity extends BaseActivity {

	/**
     * Get the XML representation for suitable for field
     *
     * @param $value
     * @param $fieldconfig
     * @param $dom
     * @param $node
     * @return $value
     */
    protected function getXMLSuitableFor($value = "", array $fieldconfig = array(), $dom = null, $node = null)
    {
        $value = parent::getXMLSuitableFor($value, $fieldconfig, $dom, $node);
        if (!is_array($value)) {
            $value = explode(",", $value);
        }
        $htmlValue = "";
        foreach ($value as $option) {
            $htmlValue .= "<li>{$option}</li>";
        }

        if ($htmlValue !== "") {
            return "<ul>{$htmlValue}</ul>";
        }

        return $value;
    }

    /**
     * Setter for related vacancies, limits the amount of related vacancies
     *
     * @param  mixed $vacancies
     */
    public function setRelatedVacancies($vacancies)
    {
        if (is_array($vacancies)) {
            $vacancies = array_unique($vacancies);
            foreach (array_splice($vacancies, 0, 4) as & $vacancy) {
                if (!($vacancy instanceof WMMongoDBRef)) {
                    $vacancy = WMMongoDBRef::create("Vacancy", $vacancy);
                }
            }
        }

        parent::setRelatedVacancies($vacancies);
    }

    /**
     * Add a status change form instead of a string when the view is "company"
     *
     * @param $value
     * @param $config
     * @param $dom
     * @param $node
     * @return $result
     */
    public function getXMLStatus($value = null, $config = null, $dom = null, $node = null)
    {
        $result = parent::getXMLStatus($value, $config, $dom, $node);

        if ($this->view == "company") {
            $employer_module = WMContentTemplate::getModuleName("{Wmemployereportfolio}");
            $form = $employer_module::getStatusUpdateForm($this);

            if (($nodelist = $node->getElementsByTagname("status")) && $nodelist->length > 0) {
                $node = $nodelist->item(0);
                $form->toXML($dom, $node);
                $result = "";
            }
        }

        return $result;
    }

}