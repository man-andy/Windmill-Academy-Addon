<?php

namespace ConnectHolland\Eportfolio\Addon\Academy\Mongo;

use Windmill\Modules\Wmactivityeportfolio\Activityevent as BaseActivityevent;

class Activityevent extends BaseActivityevent {

	 /**
     * Save the date the course was put online
     *
     * @return boolean
     */
    public function save()
    {
        $this->saveAdditional();

        return parent::save();
    }

    /**
     * saveAdditional
     *
     * Adds additional data
     *
     * @return void
     */
    protected function saveAdditional()
    {
        parent::saveAdditional();
        $this->updateStatus();
    }

	/**
     * Add a status change form instead of a string when the view is "company"
	 * 
     * @param $value
     * @param $config
     * @param $dom
     * @param $node
     * @return array $result
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

    /**
     * Updates the status according to the the data of this event
     *
     * @return void
     */
    public function updateStatus()
    {
        $statusReason = null;
        if ($this->isOpen() && intval($this->getAmountpositions()) !== 0 && ($this->getAmountpositions() - intval($this->getAmountapplications())) <= 0) {
            $this->setStatus("filled");
            $statusReason = "status_filled";
        }

        if ($this->isOpen() && !empty($this->getStartdate()) && $this->getStartdate() < new MongoDate()) {
            $this->setStatus("expired");
            $statusReason = "status_expired";
        }

        if ($this->isOpen() && !empty($this->getDeadline()) && $this->getDeadline() < new MongoDate()) {
            $this->setStatus("closed");
            $statusReason = "status_closed";
        }

        if ($this->isOpen() && intval($this->getMinimumAmountpositions()) !== 0 && (intval($this->getMinimumAmountpositions()) >= intval($this->getAmountapplications()))) {
            $this->setStatus("conditional");
            $statusReason = "status_conditional";
        }

        if ("conditional" == $this->getStatus() && (intval($this->getMinimumAmountpositions()) <= intval($this->getAmountapplications()))) {
            $this->setStatus("vacant");
            $statusReason = "status_conditional_vacant";
        }

        if (!empty($statusReason)) {
            $this->setStatusReason(WMCommonRegistry::get("wmlanguage")->userfriendlyTranslate($statusReason, "mongoobjects." . $this->getCollectionName()));
        }
    }

    /**
     * Returns true if the activityevent has an open status
     *
     * @return boolean
     */
    public function isOpen()
    {
        return in_array($this->getStatus(), (array) $this->getPublicationStatusList());
    }

}