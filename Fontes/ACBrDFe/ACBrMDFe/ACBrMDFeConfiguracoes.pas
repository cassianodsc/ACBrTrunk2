{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|* Historico
|*
|* 01/08/2012: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrMDFeConfiguracoes;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrDFeConfiguracoes, pcnConversao, pmdfeConversaoMDFe;

type

  { TGeralConfMDFe }

  TGeralConfMDFe = class(TGeralConf)
  private
    FVersaoDF: TVersaoMDFe;

    procedure SetVersaoDF(const Value: TVersaoMDFe);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeGeralConfMDFe: TGeralConfMDFe); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

  published
    property VersaoDF: TVersaoMDFe read FVersaoDF write SetVersaoDF default ve100;
  end;

  { TDownloadConfMDFe }

  TDownloadConfMDFe = class(TPersistent)
  private
    FPathDownload: String;
    FSepararPorNome: Boolean;
  public
    Constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property PathDownload: String read FPathDownload write FPathDownload;
    property SepararPorNome: Boolean read FSepararPorNome write FSepararPorNome default False;
  end;

  { TArquivosConfMDFe }

  TArquivosConfMDFe = class(TArquivosConf)
  private
    FEmissaoPathMDFe: boolean;
    FSalvarApenasMDFeProcessados: boolean;
    FNormatizarMunicipios: Boolean;
    FPathMDFe: String;
    FPathEvento: String;
    FPathArquivoMunicipios: String                                           ;
    FDownloadMDFe: TDownloadConfMDFe;
  public
    constructor Create(AOwner: TConfiguracoes); override;
    destructor Destroy; override;
    procedure Assign(DeArquivosConfMDFe: TArquivosConfMDFe); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

    function GetPathMDFe(Data: TDateTime = 0; CNPJ: String = ''): String;
    function GetPathEvento(tipoEvento: TpcnTpEvento; CNPJ: String = ''; Data: TDateTime = 0): String;
    function GetPathDownload(xNome: String = ''; CNPJ: String = ''; Data: TDateTime = 0): String;
  published
    property EmissaoPathMDFe: boolean read FEmissaoPathMDFe
      write FEmissaoPathMDFe default False;
    property SalvarApenasMDFeProcessados: boolean
      read FSalvarApenasMDFeProcessados write FSalvarApenasMDFeProcessados default False;
    property NormatizarMunicipios: boolean read FNormatizarMunicipios write FNormatizarMunicipios default False;
    property PathMDFe: String read FPathMDFe write FPathMDFe;
    property PathEvento: String read FPathEvento write FPathEvento;
    property PathArquivoMunicipios: String read FPathArquivoMunicipios write FPathArquivoMunicipios;
    property DownloadMDFe: TDownloadConfMDFe read FDownloadMDFe write FDownloadMDFe;
  end;

  { TConfiguracoesMDFe }

  TConfiguracoesMDFe = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfMDFe;
    function GetGeral: TGeralConfMDFe;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(DeConfiguracoesMDFe: TConfiguracoesMDFe); reintroduce;

  published
    property Geral: TGeralConfMDFe read GetGeral;
    property Arquivos: TArquivosConfMDFe read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
  ACBrUtil, DateUtils;

{ TConfiguracoesMDFe }

constructor TConfiguracoesMDFe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPSessaoIni := 'MDFe';
  WebServices.ResourceName := 'ACBrMDFeServicos';
end;

function TConfiguracoesMDFe.GetArquivos: TArquivosConfMDFe;
begin
  Result := TArquivosConfMDFe(FPArquivos);
end;

function TConfiguracoesMDFe.GetGeral: TGeralConfMDFe;
begin
  Result := TGeralConfMDFe(FPGeral);
end;

procedure TConfiguracoesMDFe.CreateGeralConf;
begin
  FPGeral := TGeralConfMDFe.Create(Self);
end;

procedure TConfiguracoesMDFe.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfMDFe.Create(self);
end;

procedure TConfiguracoesMDFe.Assign(DeConfiguracoesMDFe: TConfiguracoesMDFe);
begin
  Geral.Assign(DeConfiguracoesMDFe.Geral);
  WebServices.Assign(DeConfiguracoesMDFe.WebServices);
  Certificados.Assign(DeConfiguracoesMDFe.Certificados);
  Arquivos.Assign(DeConfiguracoesMDFe.Arquivos);
end;

{ TGeralConfMDFe }

procedure TGeralConfMDFe.Assign(DeGeralConfMDFe: TGeralConfMDFe);
begin
  inherited Assign(DeGeralConfMDFe);

  FVersaoDF := DeGeralConfMDFe.VersaoDF;
end;

constructor TGeralConfMDFe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FVersaoDF := ve100;
end;

procedure TGeralConfMDFe.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF));
end;

procedure TGeralConfMDFe.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  VersaoDF := TVersaoMDFe(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF)));
end;

procedure TGeralConfMDFe.SetVersaoDF(const Value: TVersaoMDFe);
begin
  FVersaoDF := Value;
end;

{ TArquivosConfMDFe }

procedure TArquivosConfMDFe.Assign(DeArquivosConfMDFe: TArquivosConfMDFe);
begin
  inherited Assign(DeArquivosConfMDFe);

  FEmissaoPathMDFe             := DeArquivosConfMDFe.EmissaoPathMDFe;
  FSalvarApenasMDFeProcessados := DeArquivosConfMDFe.SalvarApenasMDFeProcessados;
  FNormatizarMunicipios        := DeArquivosConfMDFe.NormatizarMunicipios;
  FPathMDFe                    := DeArquivosConfMDFe.PathMDFe;
  FPathEvento                  := DeArquivosConfMDFe.PathEvento;
  FPathArquivoMunicipios       := DeArquivosConfMDFe.PathArquivoMunicipios;
  FDownloadMDFe.Assign(DeArquivosConfMDFe.DownloadMDFe);
end;

constructor TArquivosConfMDFe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FDownloadMDFe := TDownloadConfMDFe.Create;
  FEmissaoPathMDFe := False;
  FSalvarApenasMDFeProcessados := False;
  FNormatizarMunicipios := False;
  FPathMDFe := '';
  FPathEvento := '';
  FPathArquivoMunicipios := '';

end;

destructor TArquivosConfMDFe.Destroy;
begin
  FDownloadMDFe.Free;
  inherited;
end;

function TArquivosConfMDFe.GetPathEvento(tipoEvento: TpcnTpEvento;
  CNPJ: String = ''; Data: TDateTime = 0): String;
var
  Dir: String;
begin
  Dir := GetPath(FPathEvento, 'Evento', CNPJ, Data);

  if AdicionarLiteral then
    Dir := PathWithDelim(Dir) + TpEventoToDescStr(tipoEvento);

  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);

  Result := Dir;
end;

function TArquivosConfMDFe.GetPathMDFe(Data: TDateTime = 0; CNPJ: String = ''): String;
begin
  Result := GetPath(FPathMDFe, 'MDFe', CNPJ, Data, 'MDFe');
end;

function TArquivosConfMDFe.GetPathDownload(xNome: String = ''; CNPJ: String = ''; Data: TDateTime = 0): String;
var
  rPathDown: String;
begin
  rPathDown := '';
  if EstaVazio(FDownloadMDFe.PathDownload) then
     FDownloadMDFe.PathDownload := PathSalvar;

  if (FDownloadMDFe.SepararPorNome) and (NaoEstaVazio(xNome)) then
     rPathDown := rPathDown + PathWithDelim(FDownloadMDFe.PathDownload) + OnlyAlphaNum(xNome)
  else
     rPathDown := FDownloadMDFe.PathDownload;

  Result := GetPath(rPathDown, 'Down', CNPJ, Data);
end;

procedure TArquivosConfMDFe.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'SalvarApenasMDFeProcessados', SalvarApenasMDFeProcessados);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'EmissaoPathMDFe', EmissaoPathMDFe);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'NormatizarMunicipios', NormatizarMunicipios);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathMDFe', PathMDFe);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathEvento', PathEvento);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathArquivoMunicipios', PathArquivoMunicipios);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'Download.PathDownload', DownloadMDFe.PathDownload);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'Download.SepararPorNome', DownloadMDFe.SepararPorNome);
end;

procedure TArquivosConfMDFe.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  SalvarApenasMDFeProcessados := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'SalvarApenasMDFeProcessados', SalvarApenasMDFeProcessados);
  EmissaoPathMDFe := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'EmissaoPathMDFe', EmissaoPathMDFe);
  NormatizarMunicipios := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'NormatizarMunicipios', NormatizarMunicipios);
  PathMDFe := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathMDFe', PathMDFe);
  PathEvento := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathEvento', PathEvento);
  PathArquivoMunicipios := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathArquivoMunicipios', PathArquivoMunicipios);
  DownloadMDFe.PathDownload := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Download.PathDownload', DownloadMDFe.PathDownload);
  DownloadMDFe.SepararPorNome := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'Download.SepararPorNome', DownloadMDFe.SepararPorNome);
end;

{ TDownloadConfMDFe }

constructor TDownloadConfMDFe.Create;
begin
  FPathDownload := '';
  FSepararPorNome := False;
end;

procedure TDownloadConfMDFe.Assign(Source: TPersistent);
begin
  if Source is TDownloadConfMDFe then
  begin
    FPathDownload := TDownloadConfMDFe(Source).PathDownload;
    FSepararPorNome := TDownloadConfMDFe(Source).SepararPorNome;
  end
  else
    inherited Assign(Source);
end;

end.
