public class Combatant {
    public PVector pos;
    float h, w;
    
    int level;
    float orientation;
    PVector velocity;
    float hp;
    float attack;
    float defence;
    
    ArrayList<Skill> skills;

    Combatant(float x, float y, float w, float h) {
        pos = new PVector(x, y);
        this.w = w;
        this.h = h;
        
        velocity = new PVector(1, 1);
        orientation = random(-PI, PI);
        hp = MAX_HEALTH;
    }

    // for a point
    boolean collides(float x, float y) {
        if (x > pos.x && x < pos.x + w && y > pos.y && y < pos.y + h) {
            return true;
        }
        return false;
    }

    // for an object with height and width
    boolean collides(float x, float y, float height, float width) {
        float left = Math.max(x, pos.x);
        float right = Math.min(x + width, pos.x + w);
        float top = Math.max(y, pos.y);
        float bottom = Math.min(y + height, pos.y + h);

        return (right > left && bottom > top);
    }

    void move(float x, float y) {
        pos.x += x;
        pos.y += y;
    }
    
    float attack(Skill skill) {
        return skill.damage * (1 + attack/100);
    }
    
    float receiveDamage(float damage) {
        float initHP = hp;
        if(defence > 0) {
            defence -= damage;
            if(defence < 0) {
                hp -= abs(defence);
                defence = 0;
            } 
        } else {
            hp -= damage;
        }
        return initHP - hp;
    }
    
    boolean isDead() {
        return hp <= 0;
    }
}
