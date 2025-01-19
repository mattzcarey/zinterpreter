pub const TokenType = []const u8;

pub const Token = struct {
    Type: TokenType,
    Literal: []const u8,
};

pub const TokenTypes = struct {
    pub const ILLEGAL: TokenType = "ILLEGAL";
    pub const EOF: TokenType = "EOF";
    pub const IDENT: TokenType = "IDENT";
    pub const INT: TokenType = "INT";
    pub const ASSIGN: TokenType = "=";
    pub const PLUS: TokenType = "+";
    pub const COMMA: TokenType = ",";
    pub const SEMICOLON: TokenType = ";";
    pub const LPAREN: TokenType = "(";
    pub const RPAREN: TokenType = ")";
    pub const LBRACE: TokenType = "{";
    pub const RBRACE: TokenType = "}";
    pub const FUNCTION: TokenType = "FUNCTION";
    pub const LET: TokenType = "LET";
};
