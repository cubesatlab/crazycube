--------------------------------------------------------------------------------
-- FILE   : state_estimator-messages.adb
-- SUBJECT: Body of a package that implements the main part of the module.
-- AUTHOR : (C) Copyright 2024 by Vermont State University
--
--------------------------------------------------------------------------------
pragma SPARK_Mode(On);

with Message_Manager;    -- See the comments in state_estimater-api.ads.
with Name_Resolver;      -- See the comments in state_estimater-api.ads.
with State_Estimator.API;  -- Needed so that the types in the API can be used here.
with CubedOS.Log_Server.API;

package body State_Estimator.Messages is
   use Message_Manager;

   -------------------
   -- Message Handling
   -------------------

   procedure Handle_Get_State_Request(Message : in Message_Record)
     with Pre => State_Estimator.API.Is_A_Request(Message)
   is
      Status : Message_Status_Type;
      GyroX : Float;
      GryoY : Float;
      GyroZ : Float;
      AccelX : Float;
      AccelY : Float;
      AccelZ : Float;
   begin
      State_Estimator.API.Get_State_Request_Decode
        (Message        => Message_Record,
         GyroscopeX     => GyroX,
         GyroscopeY     => GryoY,
         GyroscopeZ     => GyroZ,
         AccelerometerX => AccelX,
         AccelerometerY => AccelY,
         AccelerometerZ => AccelZ,
         Decode_Status  => Status);

   end Handle_Get_State_Request;

   -----------------------------------
   -- Message Decoding and Dispatching
   -----------------------------------

   procedure Process(Message : in Message_Record) is
   begin
      if State_Estimator.API.Is_Get_State_Request(Message) then
         Handle_Get_State_Request(Message);
      else
         CubedOS.Log_Server.API.Log_Message(Name_Resolver.State_Estimator,
                                            CubedOS.Log_Server.API.Error,
                                            "An unknown message type has been received!");
      end if;

   end Process;

   ---------------
   -- Message Loop
   ---------------

   task body Message_Loop is
      Incoming_Message : Message_Manager.Message_Record;
   begin
      loop
         Message_Manager.Fetch_Message(Name_Resolver.State_Estimator.Module_ID, Incoming_Message);
         Process(Incoming_Message);
      end loop;
   end Message_Loop;

end State_Estimator.Messages;
