final float ORIENTATION_INCREMENT = PI/32 ;


class Player extends Combatant {

    public Player(float x, float y) {
        this(x, y, tileWidth, tileHeight, 0);
    }

    public Player(float x, float y, float w, float h, int level) {
        super(x, y, w, h);
        this.level = level;
        skills = new ArrayList<>();
        selectSkills();
    }

    void selectSkills() {
        skills.add(Skill.PUNCH);
    }


    void display() {

        image(tiles[1][7], pos.x, pos.y, tileWidth * 2, tileHeight * 2);
        //rect(pos.x, pos.y, w, h);
        //integrate();
    }


    // wandering character.
    void integrate() {
        velocity.x = cos(orientation) ;
        velocity.y = sin(orientation) ;
        velocity.normalize() ;

        //pos.add(velocity);
        move(velocity.x, velocity.y);

        orientation += ORIENTATION_INCREMENT;

        if (orientation > PI) orientation -= 2*PI ;
        else if (orientation < -PI) orientation += 2*PI ;
    }

    void move(float x, float y, ArrayList<Area> playableArea, ArrayList<Item> dungeonItems, ArrayList<Monster> dungeonMonsters) {
        super.move(x, y);

        // stay inside playable area
        if (!inArea(playableArea)) {
            pos.x -= x;
            pos.y -= y;
        }

        // collision for items
        Iterator<Item> iter = dungeonItems.iterator();
        while (iter.hasNext()) {
            Item item = iter.next();
            if (collides(item.pos.x, item.pos.y, item.w, item.h)) {
                useItem(item);
                iter.remove();
            }
        }

        // collision for monsters
        for (Monster monster : dungeonMonsters) {
            if (monster.collides(pos.x, pos.y, w, h)) {
                gameState = State.FIGHT;
                currentMonster = monster;
            }
        }
    }

    boolean inArea(ArrayList<Area> playableArea) {
        // is in atleast one area
        for (Area area : playableArea) {
            if (area.contains(pos.x, pos.y)) {
                return true;
            }
        }
        return false;
    }

    String showAvailableSkills() {
        String availableSkills = "";
        for (int i = 0; i < skills.size(); i++) {
            availableSkills += i + 1 + ") " + skills.get(i) + "\n";
        }
        return availableSkills;
    }

    float useSkill(int index) {
        return attack(skills.get(index - 1));
    }

    void useItem(Item item) {
        switch(item.pickable) {
        case POTION:
            hp += 10;
            break;
        case POISON:
            hp -= 5;
            break;
        case SWORD:
            if (skills.contains(Skill.THREESWORDSTYLE)) {
                attack += 10;
            } else if (skills.contains(Skill.SLASH))
                skills.add(Skill.THREESWORDSTYLE);
            else if (skills.contains(Skill.CUT))
                skills.add(Skill.SLASH);
            else
                skills.add(Skill.CUT);
            break;
        case SHIELD:
            defence += 10;
            break;
        case GATE:
            gameState = State.INCREASE_LEVEL;
            break;
        default:
        }
    }

    float attack(Skill skill) {
        if (skill == Skill.SLASH || skill == Skill.THREESWORDSTYLE) {
            skills.remove(skill);
        }
        return super.attack(skill);
    }
}
