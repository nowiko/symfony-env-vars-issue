<?php

namespace App\Application\Http\Controller;

use Aws\S3\S3Client;
use FOS\RestBundle\Controller\AbstractFOSRestController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

/**
 * Class ApiController
 *
 * @package App\Application\Http\Controller
 */
class ApiController extends AbstractFOSRestController
{
    /**
     * @Route("/health-check", methods={"GET"})
     */
    public function healthCheck(
        S3Client $s3Client,
        \Swift_Mailer $mailer
    )
    {
        return new JsonResponse(
            '',
            Response::HTTP_OK
        );
    }
}
