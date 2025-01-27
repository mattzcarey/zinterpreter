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
    pub const COMMA: TokenType = ",";
    pub const SEMICOLON: TokenType = ";";

    // parentheses
    pub const LPAREN: TokenType = "(";
    pub const RPAREN: TokenType = ")";
    pub const LBRACE: TokenType = "{";
    pub const RBRACE: TokenType = "}";

    // keywords
    pub const FUNCTION: TokenType = "FUNCTION";
    pub const LET: TokenType = "LET";

    // operators
    pub const ASSIGN: TokenType = "=";
    pub const PLUS: TokenType = "+";
    pub const MINUS: TokenType = "-";
    pub const BANG: TokenType = "!";
    pub const ASTERISK: TokenType = "*";
    pub const SLASH: TokenType = "/";
    pub const LT: TokenType = "<";
    pub const GT: TokenType = ">";

    // Add new keywords
    pub const TRUE: TokenType = "TRUE";
    pub const FALSE: TokenType = "FALSE";
    pub const IF: TokenType = "IF";
    pub const ELSE: TokenType = "ELSE";
    pub const RETURN: TokenType = "RETURN";
};

const keywords = std.StaticStringMap(TokenType).initComptime(.{
    .{ "fn", TokenTypes.FUNCTION },
    .{ "let", TokenTypes.LET },
    .{ "true", TokenTypes.TRUE },
    .{ "false", TokenTypes.FALSE },
    .{ "if", TokenTypes.IF },
    .{ "else", TokenTypes.ELSE },
    .{ "return", TokenTypes.RETURN },
});

pub fn lookup_ident(ident: []const u8) TokenType {
    return keywords.get(ident) orelse TokenTypes.IDENT;
}

test "test_lookup_ident" {
    try testing.expect(std.mem.eql(u8, lookup_ident("fn"), TokenTypes.FUNCTION));
    try testing.expect(std.mem.eql(u8, lookup_ident("let"), TokenTypes.LET));
    try testing.expect(std.mem.eql(u8, lookup_ident("true"), TokenTypes.TRUE));
    try testing.expect(std.mem.eql(u8, lookup_ident("false"), TokenTypes.FALSE));
    try testing.expect(std.mem.eql(u8, lookup_ident("if"), TokenTypes.IF));
    try testing.expect(std.mem.eql(u8, lookup_ident("else"), TokenTypes.ELSE));
    try testing.expect(std.mem.eql(u8, lookup_ident("return"), TokenTypes.RETURN));
    try testing.expect(std.mem.eql(u8, lookup_ident("foo"), TokenTypes.IDENT));
}
