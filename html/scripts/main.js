/*
     ____    _    ____  _____ 
    / ___|  / \  / ___|| ____|
    | |    / _ \ \___ \|  _|  
    | |___/ ___ \ ___) | |___ 
    \____/_/   \_|____/|_____|
                           
         BUNNY INVASION
*/

// Define test players data
const test_players = [
    { name: "AceHunter", score: 120 },
    { name: "BunnyMaster", score: 105 },
    { name: "CarrotSeeker", score: 95 },
    { name: "DashingHopper", score: 90 },
    { name: "EasterEggspert", score: 85 },
    { name: "BunnyLord", score: 89 }
];

let leaderboard = null;
let banner = null;

window.addEventListener('message', event => {
    let data = event.data;
    if (data.action === 'update_leaderboard') {
        leaderboard = new Leaderboard();
        leaderboard.update_ui(data.player_scores);
    } else if (data.action === 'show_banner') {
        banner = new Banner();
        banner.render();
    } else if (data.action === 'update_banner') {
        if (banner) {
            banner.update_ui(data.text);
        }
    } else if (data.action === 'hide_banner') {
        if (banner) {
            banner.hide();
        }
    } else if (data.action === 'end_event') {
        if (banner) {
            banner.hide();
        }
        if (leaderboard) {
            leaderboard.hide();
        }
    }
});

class Leaderboard {
    constructor() {
        this.players = [];
    }
    
    test_ui() {
        this.players = test_players;
        this.render();
    }

    render() {
        this.players.sort((a, b) => b.score - a.score);
        let content = '<div class="leaderboard"><h1>LEADERBOARD</h1><ul class="leaderboard_list">';
        this.players.forEach((player, index) => {
            let position_class = '';
            let prefix = '';
            if (index === 0) {
                position_class = 'first_place';
                prefix = '🥇';
            } else if (index === 1) {
                position_class = 'second_place';
                prefix = '🥈';
            } else if (index === 2) {
                position_class = 'third_place';
                prefix = '🥉';
            }
            content += `<li class="${position_class}"><span class="position_emoji">${prefix}</span>${player.name}: <span class="player_score">${player.score}</span></li>`;
        });
        content += '</ul></div>';
        $('#main_container').append(content);
    }

    update_ui(new_scores) {
        this.players = Object.values(new_scores);
        this.render();
    }

    hide() {
        $('.leaderboard').fadeOut('fast');
    }
}

class Banner {
    constructor() {}
    
    test_ui() {
        this.render();
    }

    render() {
        let content = `
            <div id="banner" class="banner">
                <h1>BUNNY INVASION</h1>
                <div class="banner_text">
                    The bunnies have escaped! Can you capture the most!<br>Press [Y] to opt in or [N] to opt out.
                </div>
            </div>
        `
        $('#main_container').append(content);
    }

    update_ui(html) {
        $('.banner_text').html(html);
        if ($('.banner').is(':hidden')) {
            $('.banner').fadeIn('fast');
        }
        setTimeout(() => {
            this.hide();
        }, 10000);
    }

    hide() {
        $('.banner').fadeOut('fast');
    }
}

// To test the leaderboard in a web preview uncomment the lines below
//const test_leaderboard = new Leaderboard();
//test_leaderboard.test_ui();

// To test the banner in a web preview uncomment the lines below
//const test_banner = new Banner();
//test_banner.test_ui();