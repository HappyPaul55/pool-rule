<?php

namespace AppBundle\Service;

class RuleService
{
    /**
     * @var mixed[] of strings and arrays
     */
    private $ruleSets;

    /**
     * @param mixed[] $ruleSets
     *
     * @return self
     */
    public function __construct(array $ruleSets)
    {
        $this->ruleSets = $ruleSets;

        return $this;
    }

    /**
     * @param int $ruleSetsToUse
     *
     * @return string[]
     */
    public function generateRules(int $ruleSetsToUse)
    {
        if ($ruleSetsToUse < 1) {
            throw new \InvalidArgumentException('ruleSetsToUse must be 1 or higher');
        }
        $rules = [];
        foreach ((array) array_rand($this->ruleSets, $ruleSetsToUse) as $ruleSetKey) {
            $ruleSet = $this->ruleSets[$ruleSetKey];

            $rules[] = is_array($ruleSet) ? $ruleSet[array_rand($ruleSet, 1)] : $ruleSet;
        }

        return $rules;
    }
}
