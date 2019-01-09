<?php

namespace Drupal\Articlelist\Controller;

use Drupal\node\Entity\Node;
use http\Env\Response;
use Symfony\Component\VarDumper\VarDumper;
use Drupal\taxonomy\Entity\Term;

class listarticleController
{

  public function listarticle()
  {
    $entity_type_manager = \Drupal::entityTypeManager();
    $node_storage = $entity_type_manager->getStorage('node');
    $term_storage = $entity_type_manager->getStorage('taxonomy_term');

    $entities = $node_storage->loadByProperties(['type' => 'article']);
    $articles = [];
    foreach ($entities as $entity) {
      $tags = $entity->get('field_tags')->getValue();
      $tags_ids = [];
      foreach ($tags as $tag) {
        $tags_ids[] = $tag['target_id'];
      }
      $tags_entities = $term_storage->loadMultiple($tags_ids);

      $names = [];
      foreach ($tags_entities as $tags_entity) {
        $names[] = $tags_entity->getName() ?? 'no title';
      }
      $body = $entity->hasField('body') ?? $entity->get('body')->getValue();
      $articles[] = [
        'title' => $entity->getTitle(),
        'tags' => $names,
        'body' => $body,
      ];


    }

    return array(
      '#theme' => 'article',
      '#articles' => $articles ?? [],
    );
  }
}
