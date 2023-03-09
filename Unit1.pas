unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSAcc, FireDAC.Phys.MSAccDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TFormContatos = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Observações: TLabel;
    txt_ID: TEdit;
    txt_NOME: TEdit;
    txt_EMAIL: TEdit;
    txt_TEL: TEdit;
    FDConnection1: TFDConnection;
    FDContatos: TFDTable;
    DataSource1: TDataSource;
    btn_NOVO: TButton;
    btn_SALVAR: TButton;
    lbl_STATUS: TLabel;
    Label5: TLabel;
    txt_OBS: TMemo;
    btn_PRIOR: TButton;
    btn_NEXT: TButton;
    btn_EDITAR: TButton;
    btn_EXCLUIR: TButton;
    txt_PROCURA: TEdit;
    btn_PROCURA: TSpeedButton;
    btn_CANCELA: TButton;
    DBGrid1: TDBGrid;
    img_FOTO: TImage;
    btn_PESQUISAFOTO: TSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure Carrega;
    procedure Bloqueia;
    procedure Limpa;
    procedure FormCreate(Sender: TObject);
    procedure btn_NEXTClick(Sender: TObject);
    procedure btn_PRIORClick(Sender: TObject);
    procedure btn_NOVOClick(Sender: TObject);
    procedure btn_SALVARClick(Sender: TObject);
    procedure FDContatosBeforePost(DataSet: TDataSet);
    procedure btn_EXCLUIRClick(Sender: TObject);
    procedure btn_PROCURAClick(Sender: TObject);
    procedure btn_EDITARClick(Sender: TObject);
    procedure btn_CANCELAClick(Sender: TObject);
    procedure btn_PESQUISAFOTOClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormContatos: TFormContatos;
  estado: integer;
  // observacoes: String;

implementation

{$R *.dfm}

procedure TFormContatos.Bloqueia;
begin
  txt_NOME.Enabled  := not txt_NOME.Enabled;
  txt_EMAIL.Enabled := not txt_EMAIL.Enabled;
  txt_TEL.Enabled   := not txt_TEL.Enabled;
  txt_OBS.Enabled   := not txt_OBS.Enabled;
end;

procedure TFormContatos.Limpa;
begin
  txt_ID.Text    := '';
  txt_NOME.Text  := '';
  txt_EMAIL.Text := '';
  txt_TEL.Text   := '';
  txt_OBS.Text   := '';

  txt_NOME.SetFocus;
end;

procedure TFormContatos.btn_PESQUISAFOTOClick(Sender: TObject);
begin
  OpenDialog1.Execute();
  // ShowMessage(OpenDialog1.FileName);
  img_FOTO.Picture.LoadFromFile(OpenDialog1.FileName);
  FDContatos.Edit;
  FDContatos.FieldByName('foto').Value := OpenDialog1.FileName;
  FDContatos.Post;
end;

procedure TFormContatos.btn_NOVOClick(Sender: TObject);
begin
  FDContatos.Insert;
  Bloqueia;
  Limpa;
    estado := 1;
end;

procedure TFormContatos.btn_SALVARClick(Sender: TObject);
begin
  FDContatos.Post;
  Bloqueia;
end;

procedure TFormContatos.btn_PRIORClick(Sender: TObject);
begin
  FDContatos.Prior;
  Carrega;
end;

procedure TFormContatos.btn_PROCURAClick(Sender: TObject);
begin
  if Trim(txt_Procura.Text) = '' then
    ShowMessage('Digite um valor válido')
  else if not FDContatos.Locate('id', StrToInt(txt_PROCURA.Text), []) then
    ShowMessage('Valor não encontrado')
  else
    Carrega;
end;

procedure TFormContatos.btn_CANCELAClick(Sender: TObject);
begin
   Limpa;
   if estado = 1 then
    FDContatos.Prior;
   Carrega;
   Bloqueia;
   estado := 0;
end;

procedure TFormContatos.btn_EDITARClick(Sender: TObject);
begin
  Bloqueia;
  FDContatos.Edit;
end;

procedure TFormContatos.btn_EXCLUIRClick(Sender: TObject);
begin
  FDContatos.Delete;
  Carrega;
end;

procedure TFormContatos.btn_NEXTClick(Sender: TObject);
begin
  FDContatos.Next;
  Carrega;
end;

procedure TFormContatos.FDContatosBeforePost(DataSet: TDataSet);
begin
  FDContatos.FieldByName('nome').Value        := txt_NOME.Text;
  FDContatos.FieldByName('email').Value       := txt_EMAIL.Text;
  FDContatos.FieldByName('telefone').Value    := txt_TEL.Text;
  FDContatos.FieldByName('observacoes').Value := txt_OBS.Text;
end;

procedure TFormContatos.FormCreate(Sender: TObject);
begin
  FDConnection1.Params.Database := GetCurrentDir+'\assets\GestaoContatos.mdb';
  FDConnection1.Connected       := true;
  FDContatos.TableName          := 'contatos';
  FDContatos.Active             := true;

  if FDConnection1.Connected = true then
  begin
    lbl_STATUS.Caption := 'Conectado';
    carrega;
  end;
end;


procedure TFormContatos.Carrega;
begin
  if FDContatos.FieldByName('id').Value = NULL then
    txt_ID.Text := ''
  else
    txt_ID.Text := FDContatos.FieldByName('id').Value;
  if FDContatos.FieldByName('nome').Value = NULL then
    txt_NOME.Text := ''
  else
    txt_NOME.Text := FDContatos.FieldByName('nome').Value;
  if FDContatos.FieldByName('email').Value = NULL then
    txt_EMAIL.Text := ''
  else
    txt_EMAIL.Text := FDContatos.FieldByName('email').Value;
  if FDContatos.FieldByName('telefone').Value = NULL then
    txt_TEL.Text := ''
  else
    txt_TEL.Text := FDContatos.FieldByName('telefone').Value;
  if FDContatos.FieldByName('observacoes').Value = NULL then
    txt_OBS.Lines.Text := ''
  else
    txt_OBS.Lines.Text := FDContatos.FieldByName('observacoes').Value;
  if FDContatos.FieldByName('foto').Value <> NULL then
    begin
       if fileexists(FDContatos.FieldByName('foto').Value) then
        img_FOTO.Picture.LoadFromFile(FDContatos.FieldByName('foto').Value)
    end
  else
    img_FOTO.Picture := nil;
end;


procedure TFormContatos.DBGrid1DblClick(Sender: TObject);
begin
  Carrega;
end;

end.
