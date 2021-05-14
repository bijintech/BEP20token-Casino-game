<template>
  <div>
    <v-card
      color="background"
      flat
      :class="$vuetify.theme.isDark ? 'rounded-0 pa-3' : 'rounded-0 pa-3 bgm'"
    >
      <v-card-title
        class="text-sm-h5 text-xs-h6 font-weight-bold secondary--text"
        >Welcome to the DeFi Gaming World on Fantom! PLAY! Farm! Have Fun!
      </v-card-title>
      <v-card-actions>
        <router-link
          to="/exchange"
          style="text-decoration: none; color: inherit"
        >
          <v-btn color="secondary" x-large class="rounded-lg px-7"
            >Buy
            <v-img
              :src="require('../assets/DICE-COIN.png')"
              width="40"
              contain
              class="mx-3"
            />
            Farm, Play and Earn!
          </v-btn>
        </router-link>
      </v-card-actions>
    </v-card>
    <v-container>
      <div class="items">
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
            <v-img
              width="120"
              class="bg"
              :src="require('../assets/DICE-TOKEN.png')"
              contain
            />
            <v-card-title>Swap, Farm & Play</v-card-title>
            <v-list-item three-line>
              <v-list-item-content>
                <v-list-item-title class="subtitle-2"
                  >DICE to Harvest:
                </v-list-item-title>
                <v-list-item-subtitle class="grey--text"
                  >LOCKED
                </v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list-item three-line>
              <v-list-item-content>
                <v-list-item-title class="subtitle-2"
                  >DICE in Wallet:
                </v-list-item-title>
                <v-list-item-subtitle class="grey--text"
                  >LOCKED
                </v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list color="transparent">
              <v-list-item>
                <v-btn
                  rounded
                  color="#01659c"
                  elevation="0"
                  @click="unlockWallet()"
                  block
                  >{{walletStatus}}
                </v-btn>
              </v-list-item>
              <v-list-item>
                <v-btn rounded color="#01659c" elevation="0" block
                  >Add DICE to metamask</v-btn
                >
              </v-list-item>
              <v-list-item>
                <v-btn rounded color="#01659c" elevation="0" @click="rewardEveryday()" block
                  >{{rewardStatus}}</v-btn
                >
              </v-list-item>
              <v-list-item>
                <v-btn rounded color="#01659c" elevation="0" @click="unlockView()" block 
                  >{{viewStatus}}
                </v-btn>
              </v-list-item>
            </v-list>
          </v-card>
        </div>
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
            <v-card-title>Announcements</v-card-title>
          </v-card>
        </div>
      </div>
      <div class="items">
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
            <v-card-title>Dice Stats</v-card-title>
            <v-list color="transparent">
              <v-list-item style="width: 100%">
                <div
                  class="primary px-3 py-2 rounded-lg"
                  style="
                    display: flex;
                    justify-content: space-between;
                    width: 100%;
                  "
                >
                  <span>Circulating Supply</span>
                  <span>$000,000,000</span>
                </div>
              </v-list-item>
              <v-list-item style="width: 100%">
                <div
                  class="px-3 py-2 rounded-lg"
                  style="
                    display: flex;
                    justify-content: space-between;
                    width: 100%;
                  "
                >
                  <span>Market Cap</span>
                  <span>$000,000,000</span>
                </div>
              </v-list-item>
              <v-list-item style="width: 100%">
                <div
                  class="px-3 py-2 rounded-lg"
                  style="
                    display: flex;
                    justify-content: space-between;
                    width: 100%;
                  "
                >
                  <span>Total DICE</span>
                  <span>$000,000,000</span>
                </div>
              </v-list-item>
              <v-list-item style="width: 100%">
                <div
                  class="px-3 py-2 rounded-lg"
                  style="
                    display: flex;
                    justify-content: space-between;
                    width: 100%;
                  "
                >
                  <span>New DICE/block</span>
                  <span>20</span>
                </div>
              </v-list-item>
            </v-list>
          </v-card>
        </div>
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
            <v-card-title>Total Value Locked (TVL)</v-card-title>
            <v-list color="transparent">
              <v-list-item>
                <v-list-item-content class="text-h3">
                  $000,000,000
                </v-list-item-content>
              </v-list-item>
              <v-list-item>
                <v-list-item-content>
                  $Across FTM DICE Farm and Pool
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card>
        </div>
      </div>
    </v-container>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  data() {
    return {
      reward: false,
      rewardStatus: "COLLECTING REWARDS"
    };
  },
  computed: {
    ...mapGetters({
      appState: 'appState',
      walletStatus: 'walletStatus',
      viewStatus: 'viewStatus'
    }),
  },
  mounted() {
    if (this.appState.diceContract) {
      this.appState.diceContract.methods.checkReward().call().then((res) => {
        this.reward = res
        if (this.reward === false) {
          this.rewardStatus = "COLLECTING REWARDS"
        } else {
          this.rewardStatus = "CLAIMING REWARDS"
        }
      })
    }
  },
  methods: {
    async unlockWallet() {
      if (typeof window.ethereum === "undefined") {
        return;
      }

      window.ethereum.request({
        method: "eth_requestAccounts",
      });
    },

    unlockView() {
      if (this.walletStatus === "CHECK WALLET") {
        var url = "https://ftmscan.com";
        window.open(url, "_blank");
        return;
      }
    },

    rewardEveryday() {
      if (this.reward === false)
        return

      this.appState.diceContract.methods
            .getReward()
            .send({ from: this.appState.walletAddress })
            .then(() => {
            })
    }
  },
};
</script>

<style scoped>
.card {
  position: relative;
  height: 100%;
}

.bg {
  position: absolute;
  top: 70px;
  right: 30px;
  opacity: 0.4;
}

.items {
  display: flex;
  justify-content: center;
}

.items__item {
  max-width: 400px;
  width: 100%;
  margin: 20px;
}

@media (max-width: 900px) {
  .card {
    position: relative;
    height: 100%;
  }

  .items {
    display: flex;
    justify-content: center;
    flex-direction: column;
  }

  .items__item {
    max-width: 90%;
  }
}
</style>