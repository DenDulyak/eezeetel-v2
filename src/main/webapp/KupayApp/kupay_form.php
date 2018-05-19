<?php
$name=$_REQUEST['name'];
$emials=$_REQUEST['ename'];


$emailid="http://kupay.co.uk/";
$email1=" info@eezeetel.com";

$headers = "From: $emials"; 
$subject = "Web Contact Data"; 

$fields = array(); 
 $fields{"name"} = "Name"; 
 $fields{"ename"} = "Email"; 

 $fields{"msg"} = "Message"; 


$body = "We have received the following information:\n\n";
foreach($fields as $a => $b){ $body .= sprintf("%20s: %s\n",$b,$_REQUEST[$a]); }
 
 $headers2 = "From:info@kupay.co.uk"; 
 $subject2 = "Thank you for contacting us"; 
 $autoreply = "Thank you for contacting us. Somebody will get back to you as soon as possible, usualy within 10mints. If you have any more questions, please consult our website at www.eezeetel.com";
 
 
 $send = mail($email1, $subject, $body, $headers);
 //$send2 = mail($email2, $subject, $body, $headers); 
 $send3 = mail($emials, $subject2, $autoreply, $headers2); 
 if($send) 

{
	echo "<script>window.alert('Thank you for contacting us. Somebody will get back to you as soon as possible, usualy within 10mints.')</script>";
	echo "<script>window.location='index.php'</script>";

 } 
 else 
 {
	 print "We encountered an error sending your mail, please notify  info@kupay.co.uk"; 
 }

 ?> 