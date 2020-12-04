function checkBlood(obj) {
    var result = '',
        b1 = obj.blood1.value,
        b2 = obj.blood2.value;
    switch (true) {
        case b1 == 'A' && b2 == 'B':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>A</strong> 型、<strong>B</strong> 型、<strong>AB</strong> 型、<strong>O</strong> 型</p>';
            break;
        case b1 == 'B' && b2 == 'A':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>B</strong> 型、<strong>A</strong> 型、<strong>AB</strong> 型、<strong>O</strong> 型</p>';
            break;
        case b1 == 'A' && b2 == 'A':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>A</strong> 型或 <strong>O</strong> 型</p>';
            break;
        case b1 == 'A' && b2 == 'O':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>A</strong> 型或 <strong>O</strong> 型</p>';
            break;
        case b1 == 'O' && b2 == 'A':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>O</strong> 型或 <strong>A</strong> 型</p>';
            break;
        case b1 == 'A' && b2 == 'AB':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p><strong>A</strong> 型 、<strong>B</strong>型、<strong>AB</strong>型、<strong>O</strong> 型</p>';
            break;
        case b1 == 'AB' && b2 == 'A':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p><strong>AB</strong>型</p>';
            break;
        case b1 == 'B' && b2 == 'B':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>B</strong> 型或 <strong>O</strong> 型</p>';
            break;
        case b1 == 'B' && b2 == 'O':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>B</strong> 型或 <strong>O</strong> 型</p>';
            break;
        case b1 == 'O' && b2 == 'B':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>O</strong>型或 <strong>B</strong>型</p>';
            break;
        case b1 == 'B' && b2 == 'AB':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p>  <strong>B</strong> 型 、<strong>A</strong>型、<strong>AB</strong>型、 <strong>O</strong> 型</p>';
            break;
        case b1 == 'AB' && b2 == 'B':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p>  <strong>AB</strong> 型</p>';
            break;
        case b1 == 'O' && b2 == 'O':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>O</strong> 型</p>';
            break;
        case b1 == 'O' && b2 == 'AB':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>O</strong> 型</p>';
            break;
        case b1 == 'AB' && b2 == 'O':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p> <strong>AB</strong>型</p>';
            break;
        case b1 == 'AB' && b2 == 'AB':
            result = '<p><strong>选择捐卵女孩的血型范围：</strong></p><p>  <strong>AB</strong>型 、<strong>A</strong>型、<strong>B</strong> 型、<strong>O</strong> 型</p>';
            break;
        default:
            return false;
    }
    document.getElementById("result").innerHTML = result;
    return false;
}