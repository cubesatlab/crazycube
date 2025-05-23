--------------------------------------------------------------------------------
-- FILE    : message_manager.adb
-- SUBJECT : Package holding the mailboxes used by CubedOS message passing.
-- AUTHOR  : (C) Copyright 2025 by Vermont State University
--
--------------------------------------------------------------------------------

with CubedOS.Generic_Message_Manager;

package Message_Manager is
  new CubedOS.Generic_Message_Manager
    (Domain_Number => 1,
     Module_Count  => 6,
     Mailbox_Size  => 6,
     Maximum_Message_Size => 256);
