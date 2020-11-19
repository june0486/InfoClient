unit InfoChkClientpas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  // ��Ǫ�� �ޱ� ���� ����//
  System.PushNotification, System.JSON, FMX.PushNotification.Android,
  // ��Ǫ�� �ޱ� ���� ����//
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.StdCtrls, FMX.Header,
  FMX.Controls.Presentation,
  MemDS, DBAccess, Uni, Data.DB, UniProvider, MySQLUniProvider, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Panel4: TPanel;
    StringGrid1: TStringGrid;
    UniConnection1: TUniConnection;
    UniQuery1: TUniQuery;
    MySQLUniProvider1: TMySQLUniProvider;
    Lbl_Server: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    // procedure StringGrid1ApplyStyleLookup(Sender:TObject);   //���ν��� �߰��Ҷ� �����Ұ�..
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
  private
    { Private declarations }
    // ��Ǫ�� �ޱ� ���� ����//
    FDeviceID : string;
    FDeviceToken : string;
    procedure OnReceiveNotificationEvent(Sender:TObject; const ServiceNotification:TPushServiceNotification);
    procedure OnServiceConnectionChange(Sender:TObject; PushChanges:TPushService.Tchanges);
    procedure REST_Token_Upload(user_id, strToken : string);
    // ��Ǫ�� �ޱ� ���� ����//
    procedure Clipboard_WriteString( mStr : string );
  public
    { Public declarations }
    procedure MemLoginChk;
    procedure ServerChk;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.iPhone55in.fmx IOS}

procedure TForm1.Button1Click(Sender: TObject);
var
  chkBtn, i: Integer;
  sAdd: string;
begin
  ServerChk;
  chkBtn := 0;
  if CheckBox1.IsChecked then
    chkBtn := chkBtn + 100;
  if CheckBox2.IsChecked then
    chkBtn := chkBtn + 10;
  if CheckBox3.IsChecked then
    chkBtn := chkBtn + 1;

  if chkBtn > 0 then
  begin

    if NOT UniConnection1.Connected then
      UniConnection1.Connected := True;
    with UniQuery1 do
    begin
      if chkBtn = 1 then
        sAdd := 'SV'
      else if chkBtn = 10 then
        sAdd := 'VI'
      else if chkBtn = 100 then
        sAdd := 'NW'
      else if chkBtn = 11 then
        sAdd := 'SV'',''VI'
      else if chkBtn = 101 then
        sAdd := 'NW'',''SV'
      else if chkBtn = 110 then
        sAdd := 'NW'',''VI'
      else
        sAdd := 'NW'',''SV'',''VI';

      Close;
      SQL.Clear;
      SQL.Add('SELECT machine,gubun,case WHEN chknow = ''Y'' then ''����'' else ''����'' end as CHK,bigo FROM infochk_machine ');
      SQL.Add(' WHERE gubun in ( ''' + sAdd + ''' ) ');
      SQL.Add(' ORDER BY gubun,machine ');
      OPEN;
      i := 0;
      while NOT EOF do
      begin

        StringGrid1.RowCount := i + 1;
        StringGrid1.Cells[0, i] := FieldByName('machine').AsString;
        StringGrid1.Cells[1, i] := FieldByName('gubun').AsString;
        StringGrid1.Cells[2, i] := FieldByName('CHK').AsString;
        StringGrid1.Cells[3, i] := FieldByName('bigo').AsString;
        inc(i);
        NEXT;
      end;
    end;

    StringGrid1.Columns[0].Width := Round(Form1.Width / 100 * 25);
    StringGrid1.Columns[1].Width := Round(Form1.Width / 100 * 15);
    StringGrid1.Columns[2].Width := Round(Form1.Width / 100 * 15);
    StringGrid1.Columns[3].Width := Round(Form1.Width / 100 * 45);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  StringGrid1.AddObject(TStringColumn.Create(Self));
  StringGrid1.AddObject(TStringColumn.Create(Self));
  StringGrid1.AddObject(TStringColumn.Create(Self));
  StringGrid1.AddObject(TStringColumn.Create(Self));
  StringGrid1.Columns[0].Header := '��Ī';
  StringGrid1.Columns[1].Header := '����';
  StringGrid1.Columns[2].Header := '����';
  StringGrid1.Columns[3].Header := '���';
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  // ��Ǫ�� �ޱ� ���� ����//
  PushService : TPushService;
  ServiceConnection : TPushServiceConnection;
  Notifications : TArray<TPushServiceNotification>;
begin
  // ��Ǫ�� �ޱ� ���� ����//
  PushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.GCM);
  ServiceConnection := TPushServiceConnection.Create(PushService);
  ServiceConnection.Active := True;
  ServiceConnection.OnChange := OnserviceConnectionChange;
  ServiceConnection.OnReceiveNotification := OnReceiveNotificationEvent;

  FDeviceID := PushService.DeviceIDValue[TPushService.TDeviceIDNames.DeviceID];
  Notifications := PushService.StartupNotifications;
  // ��Ǫ�� �ޱ� ���� ����//
  Clipboard_WriteString( FDeviceToken );

  ServerChk;
  // StringGrid1.OnApplyStyleLookup:= StringGrid1ApplyStyleLookup;
end;

procedure TForm1.MemLoginChk;
begin
  if NOT UniConnection1.Connected then
    UniConnection1.Connected := True;

  with UniQuery1 do
  begin
    //
  end;
end;


// ��Ǫ�� �ޱ� ���� ����//
procedure TForm1.OnReceiveNotificationEvent(Sender: TObject;
  const ServiceNotification: TPushServiceNotification);
begin
  ///
end;

procedure TForm1.OnServiceConnectionChange(Sender: TObject;
  PushChanges: TPushService.Tchanges);
var
  PushService : TPushService;
begin
  PushService := TPushServiceManager.Instance.GetServiceByName((TPushService.TServiceNames.GCM);
  if TPushService.TChange.DeviceToken in PushChanges then
  begin
    FDeviceToken := PushService.DeviceTokenValue[TPushService.TDeviceTokenNames.DeviceToken];
  //  REST_Token_Upload('????',FDeviceToken);
  end;

 { if (TPushService.TChange.Status in PushChanges) and (PushService.Status = TPushService.TStatus.StartupError) then
    Lbl_Server.Text := 'Error PushStart';      }
end;

procedure TForm1.REST_Token_Upload(user_id, strToken: string);
var
  sValue : TStringList;

  jSONValue  : TJSONValue;
  jSONObject : TJSONObject;
  jSONPair   : TJSONPair;
begin
  RESTClient1.BaseURL := 'http://192.168.0.123';   // WebBPushServer.exe ���� ��ġ IP Address

  RESTRequest1.Resource := 'tokeni?user_id={uid}&push_token={tid}&reg_date={rdate}';     // tokeni ���� �����ؾ� ��, tokeni URL�� ������ FRESTResponse �ȳѾ��;
  RESTRequest1.Params.ParameterByName('uid').Value    := user_id;
  RESTRequest1.Params.ParameterByName('tid').Value    := strToken;
  RESTRequest1.Params.ParameterByName('rdate').Value  := FormatDateTime( 'YYYYMMDD', now );

  RESTRequest1.Method := TRESTRequestMethod.rmPOST;   //  or RESTRequest1.Method := TRESTRequestMethod.rmGET;
  RESTRequest1.Execute;

  // json �׸� �Ľ��Ͽ� ������ ���� ---------------------------
  sValue := TStringList.Create;

  jSONValue := TJSONObject.ParseJSONValue( RESTResponse1.Content );
  jSONObject := jSONValue as TJSONObject;

  jSONPair := JSONObject.Pairs[0];              // {����:������} �����ε� ù ����
  sValue.Add( jSONPair.JsonString.Value );
  sValue.Add( jSONPair.JsonValue.Value );

  jSONPair := jSONObject.Pairs[1];               // �����ε� �ι�° ����
  sValue.Add( JSONPair.JsonString.Value );
  sValue.Add( JSONPair.JsonValue.Value );

  if ( sValue[0] = 'return_cd' ) and ( sValue[1] = '1' ) then
     ShowMessage( '��ū ���� ���')

  else if ( sValue[0] = 'return_cd' ) and ( sValue[1] = '0' ) then
     ShowMessage( '��ū ��� ����')

  else
     ShowMessage( '���� �������̽� ����');
end;
// ��Ǫ�� �ޱ� ���� ����//
procedure TForm1.ServerChk;
begin
  if NOT UniConnection1.Connected then
    UniConnection1.Connected := True;
  with UniQuery1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT chktime from infochk_machine WHERE machine = ''AppServer'' AND ip_addr=''127.0.0.1'' AND gubun =''AS'' ');
    OPEN;
    if NOT EOF then
      Lbl_Server.Text := '����:';  FieldByName('chktime').AsString;
  end;
end;

procedure TForm1.StringGrid1DrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var
  RowColor: TBrush;
begin
  RowColor := TBrush.Create(TBrushKind.Solid, TAlphaColors.Alpha);
  if Value.ToString = '����' then
    RowColor.Color := TAlphaColors.Red
  else
    RowColor.Color := TAlphaColors.White;

  Canvas.FillRect(Bounds, 0, 0, [], 1, RowColor);
  Column.DefaultDrawCell(Canvas, Bounds, Row, Value, State);
  // TGrid(Sender).DefaultDrawColumnCell(canvas,column,Bounds,Row,Value,State);
end;

procedure TForm1.Clipboard_WriteString( mStr : string );
var
  ClipService : IFMXClipboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService) then
  begin
    ClipService := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
    ClipService.SetClipboard( mStr );
  end;
end;

{ //���ν��� �߰��Ҷ� �����Ұ�..
  procedure TForm1.StringGrid1ApplyStyleLookup(Sender: TObject);
  var  H:THeader;
  T:THeaderItem;
  A:Integer;
  begin
  if StringGrid1.FindStyleResource<THeader>('header', H) then
  begin
  H.Height := 30;
  for A:=0 to H.Count-1 do
  begin
  T:=THeaderItem(H.Items[A]);
  T.StyledSettings:=[TStyledSetting.FontColor];
  T.TextSettings.HorzAlign:=TTextAlign.Center;
  //        T.TextSettings.FontColor:=TAlphacolors.Yellow;
  T.TextSettings.Font.Family := '����ü';
  T.TextSettings.Font.Size:=20;
  end;
  end;

  end;
}
end.
