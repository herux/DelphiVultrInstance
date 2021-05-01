unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Math.Vectors, REST.Types, REST.Client, Data.Bind.Components, System.JSON,
  Data.Bind.ObjectScope, FMX.Objects, FMX.Controls3D, FMX.Layers3D, FMX.Layouts,
  FMX.ListBox, FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation, FMX.TabControl;

type
  TForm2 = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    WedgewoodLightSB: TStyleBook;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Rectangle2: TRectangle;
    Edit1: TEdit;
    SearchEditButton1: TSearchEditButton;
    Layout25: TLayout;
    Label17: TLabel;
    ListBox13: TListBox;
    Layout3D1: TLayout3D;
    Rectangle1: TRectangle;
    Image1: TImage;
    Image2: TImage;
    Label10: TLabel;
    Label11: TLabel;
    edtPAT: TEdit;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    procedure DoTrashButtonClick(Sender: TObject);
    procedure edtPATKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
  private
   FPersonalAccessToken: string;
    { Private declarations }
    function CreateInstance(): String;
    procedure DeleteInstance(AnInstanceID: string;  AItemIndex: integer);
    function GetAllInstance(APage: integer): TJSONObject;

    function InstanceCommand(AnInstanceID: string; ACommand: string): boolean;

    function CreateListBoxItem(AIndex: integer; AId: string; AName: string): TListBoxItem;
  public
    { Public declarations }
    property PersonalAccessToken: string read FPersonalAccessToken write FPersonalAccessToken;
  end;

const
  VULTR_API_BASE_PATH = 'https://api.vultr.com/v2';
var
  Form2: TForm2;

implementation

{$R *.fmx}
{$R *.Macintosh.fmx MACOS}
{$R *.Windows.fmx MSWINDOWS}

{ TForm2 }

procedure TForm2.Button1Click(Sender: TObject);
begin
  CreateInstance;
end;

function TForm2.CreateInstance: String;
var
  LRestClient: TRESTClient;
  LRestRequest: TRESTRequest;
  LReqBody, LResp: TJSONObject;
  LItemLB: TListBoxItem;
begin
  LRestClient := TRESTClient.Create(VULTR_API_BASE_PATH + '/instances');
  LRestRequest:= TRESTRequest.Create(nil);
  LReqBody :=  TJSONObject.Create;
  try
    // creating new instance req body
    LReqBody.AddPair('region','ewr');
    LReqBody.AddPair('plan','vc2-6c-16gb');
    LReqBody.AddPair('label','Example Instance'); //'VULTR.Delphi'+ListBox13.Count.ToString+'.Instance'
    LReqBody.AddPair('os_id', TJSONNumber.Create(215));
    LReqBody.AddPair('user_data','QmFzZTY0IEV4YW1wbGUgRGF0YQ');
    LReqBody.AddPair('backups','enabled');

    LRestRequest.Method := rmPOST;
    LRestRequest.AddParameter('Authorization', 'Bearer ' + PersonalAccessToken, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    LRestRequest.AddBody(LReqBody.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
    LRestRequest.Client := LRestClient;
    LRestRequest.Execute;
    LResp := (LRestRequest.Response.JSONValue as TJSONObject).GetValue('instance') as TJSONObject;
    LItemLB := CreateListBoxItem(ListBox13.Count, LResp.GetValue('id').Value, LResp.GetValue('label').Value);
    ListBox13.AddObject(LItemLB);
    Result := LRestRequest.Response.JSONText;
  finally
    LRestRequest.Free;
    LRestClient.Free;
    LReqBody.Free;
  end;
end;

function TForm2.CreateListBoxItem(AIndex: integer; AId: string; AName: string): TListBoxItem;
var
  vLayout: TLayout;
  vBtnTrash: TButton;
  vDroplLabel: TLabel;
begin
  Result := TListBoxItem.Create(ListBox13);
  vLayout := TLayout.Create(nil);
  vLayout.Align := TAlignLayout.Top;
  vLayout.Size.Height := 19;
  vLayout.Size.PlatformDefault := False;
  vLayout.Size.Width := 636;
  vBtnTrash:= TButton.Create(vLayout);
  vBtnTrash.StyleLookup := 'trashtoolbutton';
  vBtnTrash.Anchors := [TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];
  vBtnTrash.Align := TAlignLayout.Right;
  vBtnTrash.ControlType := TControlType.Styled;
  vBtnTrash.Size.Height := 35;
  vBtnTrash.Size.PlatformDefault := False;
  vBtnTrash.Size.Width := 35;
  vBtnTrash.OnClick := DoTrashButtonClick;
  vBtnTrash.Tag := index;
  vBtnTrash.TagString := AId;
  vLayout.AddObject(vBtnTrash);
  vDroplLabel := TLabel.Create(vLayout);
  vDroplLabel.Align := TAlignLayout.Client;
  vDroplLabel.Text := AName;
  vLayout.AddObject(vDroplLabel);
  Result.AddObject(vLayout);
end;

procedure TForm2.DeleteInstance(AnInstanceID: string; AItemIndex: integer);
var
  LRestClient: TRESTClient;
  LRestRequest: TRESTRequest;
begin
  LRestClient := TRESTClient.Create(VULTR_API_BASE_PATH + '/instances/' + AnInstanceID);
  LRestRequest:= TRESTRequest.Create(nil);
  try
    try
      LRestRequest.Method := rmDELETE;
      LRestRequest.AddParameter('Authorization', 'Bearer ' + PersonalAccessToken, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
      LRestRequest.Client := LRestClient;
      LRestRequest.Execute;
      ListBox13.Items.Delete(AItemIndex);
    except
      on E:Exception do
        ShowMessage('Delete instance failed');
    end;
  finally
    LRestRequest.Free;
    LRestClient.Free;
  end;
end;

procedure TForm2.DoTrashButtonClick(Sender: TObject);
begin
  DeleteInstance((Sender as TButton).TagString, (Sender as TButton).Tag);
end;

procedure TForm2.edtPATKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    vkReturn: GetAllInstance(1);
  end;
end;

function TForm2.GetAllInstance(APage: integer): TJSONObject;
var
  LRestClient: TRESTClient;
  LRestRequest: TRESTRequest;
  LDroplets: TJSONArray;
  I: Integer;
  LLBInstance: TListBoxItem;
  LLayout: TLayout;
  LBtnTrash: TButton;
  LDroplLabel: TLabel;
begin
  LRestClient := TRESTClient.Create(VULTR_API_BASE_PATH + '/instances');
  LRestRequest:= TRESTRequest.Create(nil);
  try
    LRestRequest.Method := rmGET;
    LRestRequest.AddParameter('Authorization', 'Bearer ' + edtPAT.Text, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    LRestRequest.Client := LRestClient;
    LRestRequest.Execute;
    Result := LRestRequest.Response.JSONValue as TJSONObject;
    LDroplets := Result.GetValue('instances') as TJSONArray;
    I := 0;
    for I := 0 to LDroplets.Count - 1 do begin
      LLBInstance := CreateListBoxItem(I,
        (LDroplets.Items[I] as TJSONObject).GetValue('id').Value,
        (LDroplets.Items[I] as TJSONObject).GetValue('label').Value);
      ListBox13.AddObject(LLBInstance);
    end;
    PersonalAccessToken := edtPAT.Text;
    edtPAT.Visible := False;
  finally
    LRestRequest.Free;
    LRestClient.Free;
  end;
end;

function TForm2.InstanceCommand(AnInstanceID, ACommand: string): boolean;
var
  LRestClient: TRESTClient;
  LRestRequest: TRESTRequest;
  LReqBody, LResp: TJSONObject;
  LItemLB: TListBoxItem;
begin
  LRestClient := TRESTClient.Create(VULTR_API_BASE_PATH + '/instances/'+AnInstanceID+'/'+ACommand);
  LRestRequest:= TRESTRequest.Create(nil);
  LReqBody :=  TJSONObject.Create;
  try
    LRestRequest.Method := rmPOST;
    LRestRequest.AddParameter('Authorization', 'Bearer ' + PersonalAccessToken, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    LRestRequest.AddBody(LReqBody.ToJSON, TRESTContentType.ctAPPLICATION_JSON);
    LRestRequest.Client := LRestClient;
    LRestRequest.Execute;
    LResp := (LRestRequest.Response.JSONValue as TJSONObject).GetValue('instance') as TJSONObject;
    LItemLB := CreateListBoxItem(ListBox13.Count, LResp.GetValue('id').Value, LResp.GetValue('label').Value);
    ListBox13.AddObject(LItemLB);
    Result := LRestRequest.Response.JSONText;
  finally
    LRestRequest.Free;
    LRestClient.Free;
    LReqBody.Free;
  end;
end;

end.
