const std = @import("std");
const testing = std.testing;

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

pub const keywords = struct {
    pub fn get(text: []const u8) ?TokenType {
        if (std.mem.eql(u8, text, "fn")) return TokenTypes.FUNCTION;
        if (std.mem.eql(u8, text, "let")) return TokenTypes.LET;
        return null;
    }
};

pub fn lookup_ident(ident: []const u8) TokenType {
    if (keywords.get(ident)) |tok| {
        return tok;
    }
    return TokenTypes.IDENT;
}

test "test_lookup_ident" {
    try testing.expect(std.mem.eql(u8, lookup_ident("fn"), TokenTypes.FUNCTION));
    try testing.expect(std.mem.eql(u8, lookup_ident("let"), TokenTypes.LET));
    try testing.expect(std.mem.eql(u8, lookup_ident("foo"), TokenTypes.IDENT));
}
