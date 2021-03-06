<?php

require_once __DIR__ . '/../lib/silex/silex.phar';
require_once __DIR__ . '/../lib/php-serial/php_serial.class.php';

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

$app = new Silex\Application();

$app->register(new Silex\Extension\SessionExtension());
$app['session']->start();

//use twig extension
$app->register(new Silex\Extension\TwigExtension(), array(
    'twig.path' => __DIR__ . '/../views',
    'twig.class_path' => __DIR__ . '/../lib/twig/lib',
));

//print php serial errors
$app->error(function (\Exception $e) use ($app) {
  return $app->redirect('/');
});

//log error from php_serial to "console"
set_error_handler( create_function('$a,$b','echo $b."<br />";') );


//index / import file
$app->match('/', function () use ($app) {

  //import new pattern from file
  if( isset( $_FILES['wif_file'] ) && file_exists($_FILES['wif_file']['tmp_name']) ){
    $data = parse_ini_file( $_FILES['wif_file']['tmp_name'], true );
    
    $pattern = array();
    foreach( $data['TREADLING'] as $key => $pedal ){
      $activeShafts = explode(',', $data['TIEUP'][$pedal] );
      
      $state = array();
      for( $i=1; $i<=24; $i++ ){
        if( in_array( $i, $activeShafts ) ){
          $state[$i] = true;
        }
        else{
          $state[$i] = false;
        }
      }
      $pattern[$key] = $state;
    }
    $app['session']->set('pattern', $pattern);
    
    $filename = $_FILES['wif_file']['name'];
    $app['session']->set('filename', $filename );
  }
  //or read from session
  else{
    $pattern = $app['session']->get('pattern');
    $filename = $app['session']->get('filename');
  }
  
//  var_dump( $pattern );
  
  return $app['twig']->render('index.twig', array( 'pattern' => $pattern, 'filename' => $filename  ) );
  
});


//send to board
$app->match('/send', function () use ($app) {
  
  // mac
//  define('SERIALPORT','/dev/tty.usbmodemfd131');

  // nix
  define('SERIALPORT','/dev/ttyACM0');
  
  echo 'status: <i>'.join('-', $_REQUEST['msg'] ).'</i> ('.SERIALPORT.')<br />'; 
  
  $serial = new phpSerial();
  
  $serial->deviceSet( SERIALPORT );
  
  $serial->confBaudRate(9600); //Baud rate: 9600
  $serial->confParity("none");  //Parity (this is the "N" in "8-N-1")
  $serial->confCharacterLength(8); //Character length (this is the "8" in "8-N-1")
  $serial->confStopBits(1);  //Stop bits (this is the "1" in "8-N-1")

  $serial->deviceOpen(); 
  
  $msg = $_REQUEST['msg'];
  foreach( $msg as $key => $val){
          $msg[$key] =  bindec($val);
  } 
  
  echo '<br /><br />mission control says: <br />';
  echo join(' ', $msg )."<br />";
  
  $serial->sendMessage( join(' ', $msg )."\r\n"  );
  
//  echo '<br /><br />loom says: <br />';
//  echo $serial->readPort();
  
//  $serial->deviceClose();

});


$app->run();