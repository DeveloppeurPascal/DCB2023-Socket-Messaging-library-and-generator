program MultiUserDrawServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Olf.Net.Socket.Messaging in '..\Olf.Net.Socket.Messaging.pas',
  UMultiUserDrawMessages in '..\UMultiUserDrawMessages.pas';

type
  TMyServer = class(TMultiUserDrawServer)
  public
    procedure doReceiveMUDAddAPixelMessage(Const ASender
      : TOlfSMSrvConnectedClient; Const AMessage: TMUDAddAPixelMessage);
  end;

var
  Server: TMyServer;

  { TMyServer }

procedure TMyServer.doReceiveMUDAddAPixelMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TMUDAddAPixelMessage);
var
  msg: TMUDChangePixelColorFromAnOtherUserMessage;
begin
  msg := TMUDChangePixelColorFromAnOtherUserMessage.Create;
  try
    msg.Color := AMessage.Color;
    msg.X := AMessage.X;
    msg.y := AMessage.y;
    SendMessageToAll(msg, ASender);
  finally
    msg.Free;
  end;
end;

begin
  try
    Server := TMyServer.Create('0.0.0.0', 8080);
    Server.onReceiveMUDAddAPixelMessage := Server.doReceiveMUDAddAPixelMessage;
    Server.Listen;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
