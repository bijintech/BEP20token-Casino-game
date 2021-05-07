<template>
  <v-card class="background rounded-xl card">
        <div class="top">
            <div class="icon">
                <v-img width="60" :src="require('../assets/DICE-COIN.png')" />
            </div>
            <div class="right">
                <div class="font-weight-bold text-h5">DICE-FTM LP</div>
                <div class="secondary px-2 py-1 rounded-xl">5X</div>
            </div>
        </div>
        <div class="body">
            <div>
                <div class="body__item">
                    <div>APR:</div>
                    <div>589.95%</div>
                </div>
                <div class="body__item">
                    <div>Earn:</div>
                    <div>DICE</div>
                </div>
                <div class="body__item">
                    <div>Deposit Fee:</div>
                    <div class="secondary px-2 py-1 rounded-xl">0%</div>
                </div>
            </div>
            <div class="my-3">
                <div class="secondary--text subtitle-2">DICE EARN</div>
                <div class="body__item">
                    <div class="text-h4 grey--text">0</div>
                    <div class="grey px-4 py-2 rounded-xl">Harvest</div>
                </div>
            </div>
            <div class="my-4">
                <div class="secondary--text subtitle-2">DICE-FTM LP STAKED</div>
                <v-btn block large rounded color="primary" class="my-2" @click="dialog = true">Unlock Wallet</v-btn>
            </div>
       </div>
       <v-divider></v-divider>
       <v-expansion-panels focusable flat>
        <v-expansion-panel class="transparent">
                <v-expansion-panel-header>Detail</v-expansion-panel-header>
                <v-expansion-panel-content>
                    <div class="body__item">
                        <div>Deposit:</div>
                        <div>WBTC-FTM LP</div>
                    </div>
                    <div class="body__item">
                        <div>Total Liquidity:</div>
                        <div>$000,000,000</div>
                    </div>
                    <div class="body__item">
                        <div>LP price:</div>
                        <div>~0</div>
                    </div>
                </v-expansion-panel-content>
            </v-expansion-panel>
       </v-expansion-panels>
       <v-dialog v-model="dialog" width="500">
        <v-card class="rounded-xl card" color="background" flat elevation="0">
          <v-app-bar flat color="rgba(0, 0, 0, 0)">
              <v-toolbar-title class="title white--text pl-0">
                Farming!
              </v-toolbar-title>
              <v-spacer></v-spacer>
              <v-btn icon @click="dialog = false">
                <v-icon>mdi-close</v-icon>
              </v-btn>
            </v-app-bar>
          <v-card-text>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          </v-card-text>
        </v-card>
      </v-dialog>
  </v-card>
</template>

<script>
export default {
    data(){
        return{
            dialog: false
        }
    }
}
</script>

<style scoped>
.card{
    box-sizing: border-box;
    padding: 25px;
}
.top{
    display: flex;
    justify-content: space-between;
}
.top .icon{}
.top .right{
    display: flex;
    flex-direction: column;
    align-items: flex-end;
}

.body{
    
}
.body__item{
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
</style>