<?php

namespace Drupal\Articlelist\Controller;

use Drupal\node\Entity\Node;
use http\Env\Response;

class listarticleController
{

  public function listarticle()
  {

    $entities = \Drupal::entityTypeManager()->getStorage('node')->loadByProperties(['type' => 'article']);
    $articles = [];
    foreach ($entities as $entity) {
      $articles[] = [
        'title'      => $entity->getTitle(),
        'field_tags' => $entity->get('field_tags')->getValue(),
        'body'       => $entity->get('body')->getValue(),
      ];
    }


//    dump($articles); die();
//    $testarticle = \Drupal::entityTypeManager()->getStorage('node')->loadMultiple(['type' => 'article']);
//    foreach ($testarticle as $item)
//    {
//      $table [] = [
//        'file' => $item->getTitle() ,
//        'tags' => $item->get('field_tags')->getvalue(),
//        'body' => $item->get('body')->getvalue(),
//       $variable = $item->get('body') ->getvalue()
//        if($variable != 0){
//          echo "good program";
//        }
//
//      ];
//    }
//    var_dump($articles);

    return array(
      '#theme'  => 'article',
      '#articles'=>$articles,
    );
  }
}
