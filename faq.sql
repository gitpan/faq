# MySQL dump 8.16
#
# Host: localhost    Database: faq
#--------------------------------------------------------
# Server version	4.0.15-max

#
# Table structure for table 'faq'
#

CREATE TABLE faq (
  question text NOT NULL,
  answer text,
  last_modified datetime NOT NULL default '0000-00-00 00:00:00',
  submitted datetime NOT NULL default '0000-00-00 00:00:00',
  answered datetime NOT NULL default '0000-00-00 00:00:00',
  qid int(11) NOT NULL auto_increment,
  PRIMARY KEY  (qid)
) TYPE=MyISAM;

#
# Dumping data for table 'faq'
#

INSERT INTO faq VALUES ('How do I add a new question?','Simply type a new question into the box after it says \"If you have a question that isn\'t answered in this FAQ, type it here\" and press the \"Add Question\" button','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',1);
INSERT INTO faq VALUES ('How do I provide an answer to a question?','You need to be logged in as an administrator to do this. Press the \"Login\" button, and provide the username and password. Then there should appear some buttons to the right of each question. Click on \"Edit Answer\" to make the answer editable, and on \"Update Answer\" to save the changes you have made.','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',2);
INSERT INTO faq VALUES ('How do I add a new FAQ?','You need to be logged in as an administrator to do this (see above). Then Simply type a new question into the box which says \"type a new FAQ here\" and press the \"New FAQ\" button.','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00',3);
