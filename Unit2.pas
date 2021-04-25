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
    Label32: TLabel;
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
  private
   FPersonalAccessToken: string;
    { Private declarations }
    function CreateDroplet(): String;
    procedure DeleteDroplet(ADropletID: string;  AItemIndex: integer);
    function GetAllDroplet(APage: integer): TJSONObject;

    function CreateListBoxItem(AIndex: integer; AId: string; AName: string): TListBoxItem;
  public
    { Public declarations }
    property PersonalAccessToken: string read FPersonalAccessToken write FPersonalAccessToken;
  end;

const
  DO_DROPLET_BASE_PATH = 'https://api.vultr.com/v2/instances';
var
  Form2: TForm2;

implementation

{$R *.fmx}
{$R *.Macintosh.fmx MACOS}
{$R *.Windows.fmx MSWINDOWS}

{ TForm2 }

function TForm2.CreateDroplet: String;
begin

end;

function TForm2.CreateListBoxItem(AIndex: integer; AId,
  AName: string): TListBoxItem;
begin

end;

procedure TForm2.DeleteDroplet(ADropletID: string; AItemIndex: integer);
begin

end;

function TForm2.GetAllDroplet(APage: integer): TJSONObject;
begin

end;

end.
