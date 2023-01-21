unit Service.Contrato;

interface

uses {$ifdef fpc}
  Classes, SysUtils,
  {$else}
  System.Classes, System.SysUtils,
  {$endif}
  j4dl;

type
  IStructureService = interface
    ['{2A136861-63FE-4510-829A-021DCAE270AD}']
    function GetStructure(aTableName: string): string;
  end;

  ITipoContatoService = interface
    ['{1B420AE2-DDEE-4FFF-8B73-DF7351605B63}']
    function Load(aID, aDescricao: string; aPage: Integer = 0; aLimit: Integer = 0): string;
    function Save(aID: string; aJson: string): string;
    function Delete(aID: string): string;
  end;

  ITipoEnderecoService = interface
    ['{C681453D-AF9E-4CF2-AE18-4D27700333A5}']
    function Load(aID, aDescricao: string; aPage: Integer = 0; aLimit: Integer = 0): string;
    function Save(aID: string; aJson: string): string;
    function Delete(aID: string): string;
  end;

  IPessoaService = interface
    ['{FBCF3AA2-5949-4FDA-AB82-CB1C60E8F3A3}']
    function Load(aID, aCpfCnpj, aNomeRazao, aApelidoFantasia: string; aPage: Integer = 0; aLimit: Integer = 0): string;
    function Save(aID: string; aJson: string): string;
    function Delete(aID: string): string;
  end;

  IPessoaFotoService = interface
    ['{5DE27522-16BC-41EB-AD3C-5BD39251C62E}']
    function Load(aIDPessoa: string; aJson: TJsonObject = nil): IPessoaFotoService;
    function Insert(aIDPessoa: string; aJson: TJsonObject): IPessoaFotoService;
    function Delete(aIDPessoa: string): IPessoaFotoService;
  end;

  IPessoaContatoService = interface
    ['{C85CE8E9-0D41-4C08-8D27-E86E04B1A6DF}']
    function Load(aIDPessoa: string; aJson: TJsonObject = nil): IPessoaContatoService;
    function Insert(aIDPessoa: string; aJson: TJsonArray): IPessoaContatoService;
    function Delete(aIDPessoa: string): IPessoaContatoService;
  end;

  IPessoaEnderecoService = interface
    ['{06B70A1F-A587-4840-8F6B-A81799D621D2}']
    function Load(aIDPessoa: string; aJson: TJsonObject = nil): IPessoaEnderecoService;
    function Insert(aIDPessoa: string; aJson: TJsonArray): IPessoaEnderecoService;
    function Delete(aIDPessoa: string): IPessoaEnderecoService;
  end;

implementation

end.
