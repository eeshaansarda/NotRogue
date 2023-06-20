class Monster extends Combatant {

    Area assignedArea;

    public Monster(float x, float y, Area room, int level) {
        super(x, y, tileWidth, tileHeight);
        assignedArea = room;
        orientation = random(-PI, PI);

        this.hp = MAX_HEALTH;

        this.level = level;
        skills = new ArrayList<>();
        setMonsterStats();
    }

    void setMonsterStats() {
        switch(level) {
        case 0:
            skills.add(Skill.GROWL);
            skills.add(Skill.GROWL);
            skills.add(Skill.SCRATCH);
            break;
        case 1:
            skills.add(Skill.SCRATCH);
            velocity = new PVector(2, 2);
            break;
        case 2:
            skills.add(Skill.SCRATCH);
            skills.add(Skill.BITE);
            break;
        default:
        }
    }

    float useSkill(int index) {
        return attack(skills.get(index));
    }

    void display() {
        image(tiles[1][10], pos.x, pos.y, tileWidth * 2, tileHeight * 2);
    }

    void move(float x, float y) {
        super.move(x, y);
        if (assignedArea.collides(pos.x, pos.y, w, h)) {
            pos.x -= x;
            pos.y -= y;
        }
    }

    void integrate(Player player) {
        // if player is in the same room as monster then go towards the player
        if (!assignedArea.collides(player.pos.x, player.pos.y, player.w, player.h)) {
            velocity = new PVector(player.pos.x - pos.x, player.pos.y - pos.y);
            velocity.normalize();
            // velocity change option TODO
            velocity.mult((level+2)/1.5); // speed

            move(velocity.x, velocity.y);
        } else {
            velocity.x = cos(orientation) ;
            velocity.y = sin(orientation) ;
            velocity.normalize() ;

            //pos.add(velocity);
            move(velocity.x, velocity.y);

            orientation += ORIENTATION_INCREMENT;

            if (orientation > PI) orientation -= 2*PI ;
            else if (orientation < -PI) orientation += 2*PI ;
        }
    }
}
