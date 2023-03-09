unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    Me1: TMenuItem;
    Contatos1: TMenuItem;
    Sair1: TMenuItem;
    procedure Contatos1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm2.Contatos1Click(Sender: TObject);
begin
  FormContatos.Show;
end;


procedure TForm2.Sair1Click(Sender: TObject);
begin
  Form2.close;
end;

end.
