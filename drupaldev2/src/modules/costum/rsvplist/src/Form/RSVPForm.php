<?php
/**
 * @file
 * Contains \Drupal\rsvplist\Form\RSVPForm
 */

namespace Drupal\rsvplist\Form;

use Drupal\Core\Database\Database;
use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Symfony\Component\VarDumper\VarDumper;

/**
 * Provides a RSVP Email form.
 */
class RSVPForm extends FormBase
{

  /**
   * {@inheritdoc}
   */
  public function getFormId()
  {
    return 'rsvplist_email_form';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state)
  {
    $node = \Drupal::routeMatch()->getParameter('node');
    //    $nid = $node->nid->value;
    /*two ligne is not working*/
    $nid = FALSE;
    if (isset($node->nid)) {
      $nid = $node->nid->value;
    }
    $form['email'] = array(
      '#title' => t('Email address'),
      '#type' => 'textfield',
      '#size' => 25,
      '#description' => t("Please enter you email adresse "),
      '#required' => TRUE,
    );
    $form['submit'] = array(
      '#type'   => 'submit',
      '#value'  => t('RSVP'),
    );
    $form['nid'] = array(
      '#type'   => 'hidden',
      '#value'  => $nid,
    );
    return $form;
  }

  /**
   *(@inheritDoc)
   * validation champ email adresse
   */
  public function validateForm(array &$form, FormStateInterface $form_state){
    $value =$form_state->getValue('email');
    if($value ==! \Drupal::service('email.validator')->isValid($value)){
      $form_state->setErrorByName('email',t("please enter a valid mail",array('%mail' => $value)));
//        ,array('%mail' => $value)));
    }

  }

  /**
   *(@inheritDoc)
   */
  public function submitForm(array &$form, FormStateInterface $form_state)
  {
    // TODO: Implement submitForm() method.
    drupal_set_message(t('the form is working'));
  }

}
