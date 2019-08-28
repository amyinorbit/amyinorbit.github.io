---
title: "Syntax Trees and C"
date: 2017-09-25 15:45:00 BST
layout: post
series: "OrbitVM Diaries"
redirect_from: /post/orbitvm-diary-7/
excerpt_separator: 
---

So as I mentioned in the [last entry][1], I'm at the stage where the parser for
orbit is working -- not complete, but complete enough that it parses a file
properly, and that it provides a good framework to which I can add a feature or
two add whenever I have a few hours available to work on Orbit. That's pretty
cool in and of itself.

So after the parser comes the semantic analyser, optimiser and code generator.
In the first compiler I wrote ([palc][2], for a the Language & Compilers class),
semantic analysis and code generation calls were done inline, in each of the
parser's recognisers. I considered doing this for Orbit too, because it's
simple.

The problem with that approach is that it's not exactly flexible. Since bytecode
is generated as the parser goes down the file, you can't exactly play with the
bytecode structure, so optimisation goes out of the window. It's also not
extensible, since everything is called from the parser. So instead, I'm going
to do it using an Abstract Syntax Tree (AST).



The one thing I love about the AST is that It's a good interchange format.
Instead of having each phase written as one huge block, I can split things into
small passes that do one thing, and one thing only, to the AST. And when all
of those passes have run, the code generator can take the final version of
the tree and output bytecode. Smaller passes please me because that's easier
to write and easier to test. And since the compiler is written as a group of
libraries, other people could write their own compiler by importing those
libraries, and adding their own passes to the built-in ones. I'm not inventing
anything here obviously: [LLVM][3] and the [compilers derived from it][4]
work like that.

## Writing an AST in C

In one word: ouch. So far, C hasn't been (too) much of a problem, but big data
structures like trees are a pain to implement compared to other languages. The
AST is a collection of nodes, that can be of different sub-types (binary and
unary expressions, struct, variable and function declaration...). When you have
neither classes and inheritance, or even better, strongly typed enums or tagged
unions, it means lot of boilerplate code.

In swift for example, I'd have used enums since each case can carry "attached"
data (seriously, enums in Swift are one of its best features). Bonus point for
the fact that enums are value types, which I tend to prefer when possible.

{% highlight swift %}
enum ASTNode {
    case binaryExpr(operator: Token, lhs: ASTNode, rhs: ASTNode)
    case unaryExpr(operator: Token, rhs: ASTNode)
    ...
}

// Usage:
switch someNode {
case .binaryExpr(let token, let lhs, let rhs):
    // Do something with the node and its members
    break
case .unaryExpr(let token, let rhs):
    // Do something with the node and its members
    break
}
{% endhighlight %}

In C++, I'd have had a base `ASTNode` class, and then subclasses for each type
(less optimal, but still workable). In C, it's going to have to be a (big)
tagged union, and every time I find a node, I'll have to check the tag, then
extract the actual payload:

{% highlight C %}

typedef enum {
    AST_EXPR_BINARY,
    AST_EXPR_UNARY,
    ...
} ASTNodeType;

typedef struct _ASTNode ASTNode;

struct _ASTNode {
    ASTNodeType         type;
    union {
        struct {
            Token*      operator;
            ASTNode*    lhs;
            ASTNode*    rhs;
        } binaryExpr;
        
        struct {
            Token*      operator;
            ASTNode*    rhs;
        } unaryExpr;
        
        ...
    } as;
};

// Usage:
switch(someNode->type) {
case AST_EXPR_BINARY:
    Token* operator = someNode->as.binaryExpr.operator;
    ASTNode* lhs = someNode->as.binaryExpr.lhs;
    ASTNode* rhs = someNode->as.binaryExpr.rhs;
    
    // Do something with the node and its members
    break;

case AST_EXPR_UNARY:
    Token* operator = someNode->as.binaryExpr.operator;
    ASTNode* rhs = someNode->as.binaryExpr.rhs;
    
    // Do something with the node and its members
    break;
}

{% endhighlight %}

I've also considered faking inheritance using a base struct, embedded in each
"Derived" struct, but it doesn't really have any advantage over the manual
tagged union, and just leads to *even more* boilerplate code. In the end, I'll
get all of that to work, but it still got me tempted to switch the whole project
to swift. *Just* for the enums.

 [1]: {% post_url 2017-09-24-orbitvm-diary-6 %}
 [2]: https://github.com/amyinorbit/palc
 [3]: https://llvm.org
 [4]: https://github.com/apple/swift
