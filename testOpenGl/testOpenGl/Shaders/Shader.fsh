//
//  Shader.fsh
//  testOpenGl
//
//  Created by ASTERiS on 11/3/12.
//  Copyright (c) 2012 ASTERiS. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
