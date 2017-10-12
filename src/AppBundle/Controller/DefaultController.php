<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use AppBundle\Service\RuleService;

class DefaultController extends Controller
{
    private $ruleService;

    public function __construct(RuleService $ruleService)
    {
        $this->ruleService = $ruleService;

        return $this;
    }

    public function generateAction(Request $request)
    {
        $rules = $this->ruleService->generateRules(
            (int) $request->query->get('rules', 4)
        );

        return $this->render('default/index.html.twig', [
            'rules' => $rules,
        ]);
    }
}
